require "test_helper"

class Staff::Manager::PortfolioAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @teaching_request = create(
      :default_teaching_request,
      status: :new_request,
      lead_instructor: nil,
      subject_portfolio: nil
    )
    @subject_portfolio = create(
      :subject_portfolio,
      name: "Humanities",
      notification_email: "humanities@example.com"
    )
    @inactive_subject_portfolio = create(
      :subject_portfolio,
      name: "Inactive Portfolio",
      active: false
    )

    ActionMailer::Base.deliveries.clear
    sign_in @manager
  end

  test "manager sees only active portfolios in the assignment form" do
    get edit_staff_manager_portfolio_assignment_path(id: @teaching_request.id), xhr: true

    assert_response :success
    assert_includes response.body, @subject_portfolio.name
    assert_not_includes response.body, @inactive_subject_portfolio.name
  end

  test "unauthenticated user is redirected to sign in" do
    sign_out @manager

    get edit_staff_manager_portfolio_assignment_path(id: @teaching_request.id)

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "staff instructor receives a forbidden response" do
    sign_out @manager
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    get edit_staff_manager_portfolio_assignment_path(id: @teaching_request.id)

    assert_response :forbidden
  end

  test "manager assigns a new request and notifies the portfolio" do
    assert_emails 1 do
      patch staff_manager_portfolio_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: @subject_portfolio.id }
      }
    end

    assert_response :redirect
    assert_equal @subject_portfolio, @teaching_request.reload.subject_portfolio
    assert @teaching_request.status.in_process?
    assert_nil @teaching_request.lead_instructor
    assert_equal [@subject_portfolio.notification_email], ActionMailer::Base.deliveries.last.to
  end

  test "inactive portfolio cannot be assigned" do
    assert_no_emails do
      patch staff_manager_portfolio_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: @inactive_subject_portfolio.id }
      }
    end

    assert_response :unprocessable_entity
    assert_nil @teaching_request.reload.subject_portfolio
    assert @teaching_request.status.new_request?
  end

  test "assignment ignores forged status and instructor parameters" do
    instructor = create(:user)

    patch staff_manager_portfolio_assignment_path(id: @teaching_request.id), params: {
      teaching_request: {
        subject_portfolio_id: @subject_portfolio.id,
        lead_instructor_id: instructor.id,
        status: :done
      }
    }

    @teaching_request.reload
    assert @teaching_request.status.in_process?
    assert_nil @teaching_request.lead_instructor
  end

  test "a request cannot be assigned or notified twice" do
    patch staff_manager_portfolio_assignment_path(id: @teaching_request.id), params: {
      teaching_request: { subject_portfolio_id: @subject_portfolio.id }
    }

    assert_no_emails do
      patch staff_manager_portfolio_assignment_path(id: @teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: @subject_portfolio.id }
      }
    end

    assert_response :unprocessable_entity
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "legacy lead assignment endpoint also requires manager access" do
    sign_out @manager
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    get edit_staff_manager_assign_request_lead_path(id: @teaching_request.id)

    assert_response :forbidden
  end
end
