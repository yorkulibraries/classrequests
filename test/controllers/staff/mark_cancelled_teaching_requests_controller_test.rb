require "test_helper"

class Staff::MarkCancelledTeachingRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @teaching_request = create(:default_teaching_request, status: :assigned)
    @cancel_request = CancelRequest.create!(
      teaching_request: @teaching_request,
      user: @teaching_request.user,
      reason: "The course was cancelled."
    )

    ActionMailer::Base.deliveries.clear
    sign_in @manager
  end

  test "manager marks a request cancelled and notifies the requestor and managers" do
    assert_emails 2 do
      patch staff_mark_cancelled_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :redirect
    assert @teaching_request.reload.status.cancelled?
    assert_redirected_to staff_manager_cancel_requests_path(anchor: "cancel_request_#{@cancel_request.id}")

    subjects = ActionMailer::Base.deliveries.map(&:subject)
    assert_includes subjects, "Library class request cancellation confirmed"
    assert_includes subjects, "Cancellation completed for class request ##{@teaching_request.id}"

    requestor_email = ActionMailer::Base.deliveries.find do |mail|
      mail.subject == "Library class request cancellation confirmed"
    end
    manager_email = ActionMailer::Base.deliveries.find do |mail|
      mail.subject == "Cancellation completed for class request ##{@teaching_request.id}"
    end

    assert_equal [@teaching_request.email], requestor_email.to
    assert_equal Setting.manager_emails, manager_email.to
  end

  test "cancellation requires a recorded cancellation request" do
    @cancel_request.destroy!

    assert_no_emails do
      patch staff_mark_cancelled_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :redirect
    assert @teaching_request.reload.status.assigned?
    assert_redirected_to staff_manager_cancel_requests_path
  end

  test "completed cancellation cannot send duplicate notifications" do
    patch staff_mark_cancelled_teaching_request_path(id: @teaching_request.id)
    ActionMailer::Base.deliveries.clear

    assert_no_emails do
      patch staff_mark_cancelled_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :redirect
    assert @teaching_request.reload.status.cancelled?
  end

  test "deleted request cannot be marked cancelled" do
    @teaching_request.update!(status: :deleted)

    assert_no_emails do
      patch staff_mark_cancelled_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :redirect
    assert @teaching_request.reload.status.deleted?
  end

  test "staff instructor cannot complete a cancellation" do
    sign_out @manager
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    assert_no_emails do
      patch staff_mark_cancelled_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :forbidden
    assert @teaching_request.reload.status.assigned?
  end
end
