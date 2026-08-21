require "test_helper"

class Staff::Manager::PortfolioLeadAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @subject_portfolio = create(:subject_portfolio, name: "Humanities")
    @member = create_portfolio_member(@subject_portfolio)
    @outsider = create_portfolio_member(create(:subject_portfolio))
    @inactive_member = create_portfolio_member(@subject_portfolio)
    @inactive_member.update!(is_active: false)
    @teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: @subject_portfolio,
      lead_instructor: nil
    )

    ActionMailer::Base.deliveries.clear
    sign_in @manager
  end

  test "manager sees only currently eligible members of the request portfolio" do
    get edit_staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), xhr: true

    assert_response :success
    assert_includes response.body, @member.full_name
    assert_not_includes response.body, @outsider.full_name
    assert_not_includes response.body, @inactive_member.full_name
  end

  test "manager confirms an eligible member and all parties are notified" do
    assert_emails 3 do
      patch staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { lead_instructor_id: @member.id },
        assignment_mode: "confirmed"
      }
    end

    assert_response :redirect
    assert_equal @member, @teaching_request.reload.lead_instructor
    assert @teaching_request.status.assigned?
    recipients = ActionMailer::Base.deliveries.flat_map(&:to)
    assert_includes recipients, @member.email
    assert_includes recipients, @teaching_request.email
    Setting.manager_emails.each { |email| assert_includes recipients, email }
  end

  test "manager requests acceptance without confirming the assignment" do
    assert_emails 1 do
      patch staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { lead_instructor_id: @member.id },
        assignment_mode: "acceptance_required"
      }
    end

    assert_response :redirect
    assert_equal @member, @teaching_request.reload.lead_instructor
    assert @teaching_request.status.in_process?
    assert_equal :awaiting_response, @teaching_request.lead_assignment_state
    assert_equal [@member.email], ActionMailer::Base.deliveries.last.to
  end

  test "manager cannot submit an unknown assignment mode" do
    assert_no_emails do
      patch staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { lead_instructor_id: @member.id },
        assignment_mode: "unexpected"
      }
    end

    assert_response :unprocessable_entity
    assert_nil @teaching_request.reload.lead_instructor
    assert @teaching_request.status.in_process?
  end

  test "manager cannot assign a user outside the request portfolio" do
    assert_no_emails do
      patch staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { lead_instructor_id: @outsider.id }
      }
    end

    assert_response :unprocessable_entity
    assert_nil @teaching_request.reload.lead_instructor
    assert @teaching_request.status.in_process?
  end

  test "manager cannot assign or notify a request twice" do
    patch staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), params: {
      teaching_request: { lead_instructor_id: @member.id }
    }

    assert_no_emails do
      patch staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { lead_instructor_id: @member.id }
      }
    end

    assert_response :unprocessable_entity
    assert_equal 3, ActionMailer::Base.deliveries.size
  end

  test "staff instructor receives a forbidden response" do
    sign_out @manager
    sign_in @member

    get edit_staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id)

    assert_response :forbidden
  end

  test "unauthenticated user is redirected to sign in" do
    sign_out @manager

    get edit_staff_manager_portfolio_lead_assignment_path(id: @teaching_request.id)

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  private

  def create_portfolio_member(subject_portfolio)
    user = create(:user, is_active: true)
    create(:staff_profile, user: user, role: :staff_instructor, is_approved: true)
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: user)
    user
  end
end
