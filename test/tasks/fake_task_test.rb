require 'test_helper'
require 'rake'
require 'minitest/mock'

class FakeTaskTest < ActiveSupport::TestCase
  PORTFOLIO_TASKS = %w[
    fake:ensure_development
    fake:ensure_courses
    fake:create_subject_portfolios
    fake:repair_dummy_requests
    fake:create_dummy_portfolio_requests
    courses:load_courses
    courses:populate_missing_data
    courses:insert_library_faculty
    courses:insert_other_depts
  ].freeze

  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?('fake:create_subject_portfolios')

    @department = create(:department)
    @members = {
      'milhouse@mailinator.com' => create_staff_user('milhouse@mailinator.com', 'Milhouse', 'Van Houten'),
      'bart@mailinator.com' => create_staff_user('bart@mailinator.com', 'Bart', 'Simpson'),
      'lisa@mailinator.com' => create_staff_user('lisa@mailinator.com', 'Lisa', 'Simpson'),
      'barney@mailinator.com' => create_staff_user('barney@mailinator.com', 'Barney', 'Gumble')
    }
  end

  test 'subject portfolio task creates expected portfolios and memberships' do
    invoke_fake_task('fake:create_subject_portfolios')

    assert_equal FakeData.subject_portfolios.size, SubjectPortfolio.count

    FakeData.subject_portfolios.each do |attributes|
      portfolio = SubjectPortfolio.find_by!(name: attributes.fetch(:name))

      assert portfolio.active?
      assert_equal attributes.fetch(:notification_email), portfolio.notification_email
      assert_equal attributes.fetch(:member_emails).sort, portfolio.members.pluck(:email).sort
    end
  end

  test 'course setup loads bundled periods once before fake requests are generated' do
    with_environment('FAKE_COURSE_DATA_FILE', course_fixture_path) do
      invoke_fake_task('fake:ensure_courses')

      assert InstituteCourse.exists?(
        academic_year: '2026',
        academic_term: 'FW',
        subject_abbrev: 'ADMS',
        number: 1000
      )
      assert InstituteCourse.exists?(
        academic_year: '2026',
        academic_term: 'FW',
        subject_abbrev: 'BIOL',
        number: 1001
      )
      assert_equal 2, InstituteCourse.where.not(title: nil).count

      course_count = InstituteCourse.count
      invoke_fake_task('fake:ensure_courses')
      assert_equal course_count, InstituteCourse.count
    end
  end

  test 'subject portfolio task repairs records without duplicating memberships' do
    invoke_fake_task('fake:create_subject_portfolios')
    business = SubjectPortfolio.find_by!(name: 'Business')
    business.update!(active: false, notification_email: 'old@example.com')

    invoke_fake_task('fake:create_subject_portfolios')

    assert business.reload.active?
    assert_equal 'business-portfolio@mailinator.com', business.notification_email
    assert_equal FakeData.subject_portfolios.size, SubjectPortfolio.count
    assert_equal 8, SubjectPortfolioMembership.count
  end

  test 'portfolio request task creates one claimable request per active portfolio' do
    invoke_fake_task('fake:create_subject_portfolios')
    unrelated_portfolio = create(:subject_portfolio, name: 'Unrelated development portfolio')
    blank_term_request = create(:default_teaching_request, status: :new_request)
    blank_term_request.update_column(:academic_term, nil)
    (FakeData.subject_portfolios.size - 1).times do
      create(:default_teaching_request, status: :new_request)
    end

    invoke_fake_task('fake:create_dummy_portfolio_requests')

    SubjectPortfolio.where.not(id: unrelated_portfolio.id).find_each do |portfolio|
      request = portfolio.teaching_requests.awaiting_portfolio_lead.first

      assert request
      assert request.portfolio_claimable?
      assert_equal "Portfolio queue demo: #{portfolio.name}", request.course_title
    end

    assert_empty unrelated_portfolio.teaching_requests
    assert_equal 'Missing', blank_term_request.reload.academic_term
    assert_equal FakeData.subject_portfolios.size, TeachingRequest.awaiting_portfolio_lead.count
  end

  test 'dummy request repair changes only requests belonging to Mailinator users' do
    dummy_requestor = create(:user, email: 'requestor@mailinator.com')
    regular_requestor = create(:user, email: 'requestor@example.com')
    dummy_request = create(:default_teaching_request, user: dummy_requestor)
    regular_request = create(:default_teaching_request, user: regular_requestor)
    dummy_request.update_column(:academic_term, nil)
    regular_request.update_column(:academic_term, nil)

    invoke_fake_task('fake:repair_dummy_requests')

    assert_equal 'Missing', dummy_request.reload.academic_term
    assert_nil regular_request.reload.academic_term
  end

  test 'portfolio request task does not duplicate an existing portfolio queue' do
    invoke_fake_task('fake:create_subject_portfolios')
    SubjectPortfolio.count.times { create(:default_teaching_request, status: :new_request) }
    invoke_fake_task('fake:create_dummy_portfolio_requests')

    assert_no_difference('TeachingRequest.awaiting_portfolio_lead.count') do
      invoke_fake_task('fake:create_dummy_portfolio_requests')
    end
  end

  private

  def create_staff_user(email, first_name, last_name)
    user = create(:user, email: email, first_name: first_name, last_name: last_name)
    create(
      :staff_profile,
      user: user,
      department: @department,
      role: :staff_instructor,
      is_approved: true
    )
    user
  end

  def invoke_fake_task(name)
    PORTFOLIO_TASKS.each { |task_name| Rake::Task[task_name].reenable }

    Rails.env.stub(:development?, true) do
      capture_io { Rake::Task[name].invoke }
    end
  end

  def course_fixture_path
    Rails.root.join('test', 'fixtures', 'files', 'course-data.csv').to_s
  end

  def with_environment(key, value)
    previous_value = ENV[key]
    ENV[key] = value
    yield
  ensure
    ENV[key] = previous_value
  end
end
