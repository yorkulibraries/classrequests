require 'test_helper'

class Staff::TeachingRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @staff = create(:user, is_active: true)
    create(:staff_profile, user: @staff, role: :staff_instructor, is_approved: true)
    @subject_portfolio = create(:subject_portfolio, name: 'Humanities')
    @inactive_subject_portfolio = create(
      :subject_portfolio,
      name: 'Retired Portfolio',
      active: false
    )
    @campus_location = create(:valid_campus_location)

    ActionMailer::Base.deliveries.clear
    sign_in @staff
  end

  test 'staff backlog form lists active subject portfolios only' do
    get new_staff_teaching_request_path

    assert_response :success
    assert_select 'select#teaching_request_subject_portfolio_id' do
      assert_select "option[value='#{@subject_portfolio.id}']", text: @subject_portfolio.name
      assert_select "option[value='#{@inactive_subject_portfolio.id}']", count: 0
    end
  end

  test 'staff logs historical teaching with a subject portfolio without sending email' do
    assert_no_emails do
      assert_difference('TeachingRequest.count', 1) do
        post staff_teaching_requests_path, params: {
          teaching_request: teaching_request_params(@subject_portfolio)
        }
      end
    end

    teaching_request = TeachingRequest.order(:id).last
    assert_response :redirect
    assert_redirected_to staff_dashboard_path
    assert teaching_request.status.assigned?
    assert_equal @subject_portfolio, teaching_request.subject_portfolio
    assert_equal @staff, teaching_request.lead_instructor
  end

  test 'staff cannot forge an inactive subject portfolio into backlog work' do
    assert_no_difference('TeachingRequest.count') do
      post staff_teaching_requests_path, params: {
        teaching_request: teaching_request_params(@inactive_subject_portfolio)
      }
    end

    assert_response :success
    assert_includes response.body, I18n.t('subject_portfolios.assignment.errors.active')
  end

  private

  def teaching_request_params(subject_portfolio)
    {
      username: @staff.username,
      patron_type: :librarian_staff,
      first_name: 'Alex',
      last_name: 'Requestor',
      email: 'alex.requestor@example.com',
      academic_term: 'FW',
      academic_year: '2025-2026',
      faculty: 'Faculty of Liberal Arts and Professional Studies',
      faculty_abbrev: 'AP',
      subject: 'Humanities',
      subject_abbrev: 'HUMA',
      course_number: 1100,
      course_title: 'Historical teaching entry',
      section_name_or_about: 'Section A',
      number_of_students: 25,
      preferred_date: Date.current,
      preferred_time: '10:00',
      duration: :sixty,
      location_preference: :in_the_library,
      request_note: 'Historical teaching details',
      instructor_notes: 'Entered through the backlog form',
      status: :assigned,
      submitted_by: @staff.full_name,
      lead_instructor_id: @staff.id,
      campus_location_id: @campus_location.id,
      subject_portfolio_id: subject_portfolio.id
    }
  end
end
