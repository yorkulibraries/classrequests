require "test_helper"

class TeachingRequestTest < ActiveSupport::TestCase

  should belong_to(:subject_portfolio).optional
  should have_many(:subject_portfolio_declines).dependent(:restrict_with_error)


  ## ENUMS
  # should define_enum_for(:status).with_values(... doesn't work... use enmuerize) 

  should enumerize(:patron_type).in(faculty: 0, librarian_staff: 1, other: 9).with_default(:other)
  should enumerize(:status).in(not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, cancelled: 7, deleted: 9).with_default(:not_submitted)

  should enumerize(:duration).in(thirty: '30', sixty: '60', sixty_plus: '60+', ninety: '90', one_twenty: '120', one_fifty: '150', one_eighty: '180', one_eighty_plus: '180+')

  should enumerize(:location_preference).in(:online, :pre_recorded, :hybrid, :in_the_class, :in_the_library, :off_campus, :to_be_determined).with_default(:to_be_determined)

  ## PRESENCE
  should validate_presence_of(:patron_type)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)
  should validate_presence_of(:academic_year)
  should validate_presence_of(:faculty_abbrev)
  should validate_presence_of(:subject_abbrev)
  should validate_presence_of(:course_number)
  should validate_presence_of(:status)
  should validate_presence_of(:number_of_students)
  should validate_presence_of(:preferred_date)
  should validate_presence_of(:preferred_time)
  should validate_presence_of(:duration)
  should validate_presence_of(:location_preference)
  #should validate_presence_of(:request_note)

  ## EMAILS
  should allow_value('test@example.com', 'another@test.com').for(:email)
  should_not allow_value('invalid_email', 'test@').for(:email)

  test 'course_number rejects oversized integer values without raising range error' do
    teaching_request = FactoryBot.build(:default_teaching_request, course_number: '9999999999')

    assert_nothing_raised do
      assert_not teaching_request.save
    end

    assert_includes teaching_request.errors[:course_number], 'must be less than or equal to 9999'
  end

  test 'number_of_students rejects oversized integer values without raising range error' do
    teaching_request = FactoryBot.build(:default_teaching_request, number_of_students: '9999999999')

    assert_nothing_raised do
      assert_not teaching_request.save
    end

    assert_includes teaching_request.errors[:number_of_students], 'must be less than or equal to 9999'
  end


  ## ASSIGNMENT TARGET VALIDATION WHEN A REQUEST IS IN PROCESS
  test 'in-process request requires a lead instructor or subject portfolio' do
    teaching_request = build(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: nil,
      subject_portfolio: nil
    )

    assert_not teaching_request.valid?
    assert_includes teaching_request.errors[:base], "An in-process request must have a lead instructor or subject portfolio"
  end

  test 'in-process request remains valid with a legacy lead instructor' do
    teaching_request = build(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: create(:user),
      subject_portfolio: nil
    )

    assert teaching_request.valid?
  end

  test 'in-process request is valid with a subject portfolio and no lead instructor' do
    teaching_request = build(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: nil,
      subject_portfolio: create(:subject_portfolio)
    )

    assert teaching_request.valid?
  end

  test 'newly selected subject portfolio must be active' do
    subject_portfolio = create(:subject_portfolio, active: false)
    teaching_request = build(
      :default_teaching_request,
      status: :assigned,
      subject_portfolio: subject_portfolio
    )

    assert_not teaching_request.valid?
    assert_includes(
      teaching_request.errors[:subject_portfolio],
      I18n.t('subject_portfolios.assignment.errors.active')
    )
  end

  test 'existing request can retain a subject portfolio that was deactivated later' do
    subject_portfolio = create(:subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :assigned,
      subject_portfolio: subject_portfolio
    )
    subject_portfolio.update!(active: false)

    teaching_request.course_title = 'Updated historical teaching'

    assert teaching_request.save
    assert_equal subject_portfolio, teaching_request.reload.subject_portfolio
  end

  test 'portfolio assignment is available only for an unassigned new request' do
    teaching_request = build(
      :default_teaching_request,
      status: :new_request,
      lead_instructor: nil,
      subject_portfolio: nil
    )

    assert teaching_request.portfolio_assignable?

    teaching_request.subject_portfolio = build(:subject_portfolio)
    assert_not teaching_request.portfolio_assignable?

    teaching_request.subject_portfolio = nil
    teaching_request.lead_instructor = build(:user)
    assert_not teaching_request.portfolio_assignable?

    teaching_request.lead_instructor = nil
    teaching_request.status = :in_process
    assert_not teaching_request.portfolio_assignable?
  end

  test 'awaiting portfolio lead scope includes only unclaimed in-process portfolio requests' do
    subject_portfolio = create(:subject_portfolio)
    awaiting = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    assigned = create(
      :default_teaching_request,
      status: :assigned,
      subject_portfolio: subject_portfolio,
      lead_instructor: create(:user)
    )

    assert_includes TeachingRequest.awaiting_portfolio_lead, awaiting
    assert_not_includes TeachingRequest.awaiting_portfolio_lead, assigned
  end

  test 'subject portfolio report filter includes tagged and legacy requests separately' do
    subject_portfolio = create(:subject_portfolio)
    tagged = create(
      :default_teaching_request,
      status: :done,
      subject_portfolio: subject_portfolio
    )
    legacy = create(
      :default_teaching_request,
      status: :done,
      subject_portfolio: nil
    )

    assert_includes TeachingRequest.for_subject_portfolio_filter(''), tagged
    assert_includes TeachingRequest.for_subject_portfolio_filter(''), legacy
    assert_equal [tagged], TeachingRequest.for_subject_portfolio_filter(subject_portfolio.id).to_a
    assert_equal [legacy], TeachingRequest.for_subject_portfolio_filter(
      TeachingRequest::WITHOUT_SUBJECT_PORTFOLIO_FILTER
    ).to_a
  end

  test 'historical portfolio classification preserves status and instructors' do
    instructors = 3.times.map { create(:user) }
    subject_portfolio = create(:subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :done,
      lead_instructor: instructors[0],
      second_instructor: instructors[1],
      third_instructor: instructors[2],
      subject_portfolio: nil
    )

    assert teaching_request.classify_subject_portfolio(subject_portfolio)

    teaching_request.reload
    assert teaching_request.status.done?
    assert_equal subject_portfolio, teaching_request.subject_portfolio
    assert_equal instructors, [
      teaching_request.lead_instructor,
      teaching_request.second_instructor,
      teaching_request.third_instructor
    ]
  end

  test 'lead response remains awaiting when a portfolio is added to a legacy assignment' do
    lead_instructor = create(:user)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: lead_instructor,
      subject_portfolio: nil
    )

    assert_equal :awaiting_response, teaching_request.lead_assignment_state
    assert teaching_request.classify_subject_portfolio(create(:subject_portfolio))
    assert_equal :awaiting_response, teaching_request.lead_assignment_state
  end

  test 'accepted lead response is reported for historical work' do
    lead_instructor = create(:user)
    teaching_request = create(
      :default_teaching_request,
      status: :done,
      lead_instructor: lead_instructor
    )
    AssignmentResponse.create!(
      teaching_request: teaching_request,
      user: lead_instructor,
      response: :accept
    )

    assert_equal :accepted, teaching_request.lead_assignment_state
  end

  test 'declined lead response is reported from the response log' do
    former_lead = create(:user)
    teaching_request = create(
      :default_teaching_request,
      status: :new_request,
      lead_instructor: nil
    )
    AssignmentResponse.create!(
      teaching_request: teaching_request,
      user: former_lead,
      response: :decline
    )

    assert_equal :declined, teaching_request.lead_assignment_state
  end

  test 'direct portfolio assignment is confirmed without a response' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: nil,
      subject_portfolio: subject_portfolio
    )

    assert teaching_request.assign_portfolio_lead(member)
    assert_equal :confirmed_without_response, teaching_request.lead_assignment_state
  end

  test 'historical lead without a response log is reported as unrecorded' do
    teaching_request = create(
      :default_teaching_request,
      status: :unfulfilled,
      lead_instructor: create(:user),
      subject_portfolio: nil
    )

    assert_equal :no_response_recorded, teaching_request.lead_assignment_state
  end

  test 'historical portfolio classification is not blocked by newer validations' do
    subject_portfolio = create(:subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :done,
      subject_portfolio: nil
    )
    teaching_request.update_column(:academic_term, nil)

    assert teaching_request.classify_subject_portfolio(subject_portfolio)
    assert_equal subject_portfolio, teaching_request.subject_portfolio
    assert_nil teaching_request.academic_term
  end

  test 'classifying a new request moves it into the portfolio queue' do
    subject_portfolio = create(:subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :new_request,
      subject_portfolio: nil,
      lead_instructor: nil
    )

    assert teaching_request.classify_subject_portfolio(subject_portfolio)

    teaching_request.reload
    assert teaching_request.status.in_process?
    assert_includes TeachingRequest.awaiting_portfolio_lead, teaching_request
  end

  test 'removing a portfolio from an unclaimed request returns it to new' do
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: create(:subject_portfolio),
      lead_instructor: nil
    )

    assert teaching_request.classify_subject_portfolio(nil)

    teaching_request.reload
    assert teaching_request.status.new_request?
    assert_nil teaching_request.subject_portfolio
  end

  test 'eligible portfolio member can claim a request as lead' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )

    assert teaching_request.portfolio_claimable?
    assert teaching_request.assign_portfolio_lead(member)

    teaching_request.reload
    assert_equal member, teaching_request.lead_instructor
    assert teaching_request.status.assigned?
    assert_not teaching_request.portfolio_claimable?
  end

  test 'nonmember cannot claim a portfolio request' do
    subject_portfolio = create(:subject_portfolio)
    nonmember = create(:user, is_active: true)
    create(:staff_profile, user: nonmember, role: :staff_instructor, is_approved: true)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )

    assert_not teaching_request.assign_portfolio_lead(nonmember)
    assert_nil teaching_request.reload.lead_instructor
    assert teaching_request.status.in_process?
    assert_includes teaching_request.errors[:lead_instructor], I18n.t('subject_portfolios.claim.errors.ineligible')
  end

  test 'only the first eligible member can claim a portfolio request' do
    subject_portfolio = create(:subject_portfolio)
    first_member = create_portfolio_member(subject_portfolio)
    second_member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )

    assert teaching_request.assign_portfolio_lead(first_member)
    assert_not teaching_request.assign_portfolio_lead(second_member)
    assert_equal first_member, teaching_request.reload.lead_instructor
  end

  test 'concurrent portfolio claims allow exactly one member to become lead' do
    subject_portfolio = create(:subject_portfolio)
    members = [
      create_portfolio_member(subject_portfolio),
      create_portfolio_member(subject_portfolio)
    ]
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    ready = Queue.new
    start = Queue.new

    threads = members.map do |member|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          request_copy = TeachingRequest.find(teaching_request.id)
          ready << true
          start.pop
          request_copy.assign_portfolio_lead(member)
        end
      end
    end

    members.size.times { ready.pop }
    members.size.times { start << true }
    results = threads.map(&:value)

    assert_equal 1, results.count(true)
    assert_includes members, teaching_request.reload.lead_instructor
    assert teaching_request.status.assigned?
  end

  test 'manager can request portfolio member acceptance without confirming the request' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )

    assert teaching_request.request_portfolio_lead_acceptance(member)

    teaching_request.reload
    assert_equal member, teaching_request.lead_instructor
    assert teaching_request.status.in_process?
    assert_equal :awaiting_response, teaching_request.lead_assignment_state
  end

  test 'accepted portfolio lead response confirms the request' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: member
    )
    response = AssignmentResponse.new(user: member, response: :accept)

    assert teaching_request.record_lead_assignment_response(response)

    assert teaching_request.status.assigned?
    assert_equal member, teaching_request.lead_instructor
    assert_equal response, teaching_request.assignment_responses.last
  end

  test 'declined portfolio lead proposal returns to the same portfolio queue' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: member
    )
    response = AssignmentResponse.new(user: member, response: :decline)

    assert teaching_request.record_lead_assignment_response(response)

    assert teaching_request.status.in_process?
    assert_nil teaching_request.lead_instructor
    assert_equal subject_portfolio, teaching_request.subject_portfolio
    assert_includes TeachingRequest.awaiting_portfolio_lead, teaching_request
  end

  test 'declined legacy lead proposal returns to new requests' do
    member = create(:user)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: nil,
      lead_instructor: member
    )
    response = AssignmentResponse.new(user: member, response: :decline)

    assert teaching_request.record_lead_assignment_response(response)

    assert teaching_request.status.new_request?
    assert_nil teaching_request.lead_instructor
  end

  test 'portfolio member can return an unclaimed request with an audit record' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    decline = SubjectPortfolioDecline.new(
      declined_by: member,
      reason: "No portfolio member is available on the requested date.",
      confirmed: true
    )

    assert teaching_request.return_portfolio_to_manager(decline)

    assert teaching_request.status.new_request?
    assert_nil teaching_request.subject_portfolio
    assert_equal teaching_request, decline.teaching_request
    assert_equal subject_portfolio, decline.subject_portfolio
    assert_equal member, decline.declined_by
    assert_predicate decline, :persisted?
  end

  test 'portfolio return with a blank reason leaves the request unchanged' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    decline = SubjectPortfolioDecline.new(declined_by: member, reason: "", confirmed: true)

    assert_not teaching_request.return_portfolio_to_manager(decline)

    teaching_request.reload
    assert teaching_request.status.in_process?
    assert_equal subject_portfolio, teaching_request.subject_portfolio
    assert_equal 0, teaching_request.subject_portfolio_declines.count
  end

  test 'nonmember cannot return a portfolio request' do
    subject_portfolio = create(:subject_portfolio)
    member = create(:user, is_active: true)
    create(:staff_profile, user: member, role: :staff_instructor, is_approved: true)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    decline = SubjectPortfolioDecline.new(
      declined_by: member,
      reason: "Cannot take this request",
      confirmed: true
    )

    assert_not teaching_request.return_portfolio_to_manager(decline)

    assert teaching_request.reload.status.in_process?
    assert_equal subject_portfolio, teaching_request.subject_portfolio
    assert_includes decline.errors[:declined_by], I18n.t('subject_portfolios.decline.errors.ineligible')
  end

  test 'portfolio request cannot be returned after a lead claims it' do
    subject_portfolio = create(:subject_portfolio)
    member = create_portfolio_member(subject_portfolio)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    assert teaching_request.assign_portfolio_lead(member)
    decline = SubjectPortfolioDecline.new(
      declined_by: member,
      reason: "Too late",
      confirmed: true
    )

    assert_not teaching_request.return_portfolio_to_manager(decline)
    assert teaching_request.reload.status.assigned?
    assert_equal member, teaching_request.lead_instructor
    assert_includes decline.errors[:base], I18n.t('subject_portfolios.decline.errors.unavailable')
  end

  test 'default status value' do
    teaching_request = FactoryBot.create(:default_teaching_request)
    # puts "TeachingRequest Status: #{teaching_request.status}" 
    ## Test if default status is not_submitted.
    assert_equal 0, teaching_request.status
    # puts teaching_request.inspect
  end

  private

  def create_portfolio_member(subject_portfolio)
    user = create(:user, is_active: true)
    create(:staff_profile, user: user, role: :staff_instructor, is_approved: true)
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: user)
    user
  end

end
