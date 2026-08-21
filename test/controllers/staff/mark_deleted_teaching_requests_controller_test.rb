require "test_helper"

class Staff::MarkDeletedTeachingRequestsControllerTest < ActionDispatch::IntegrationTest
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

  test "administrative deletion does not send cancellation notifications" do
    assert_no_emails do
      patch staff_mark_deleted_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :redirect
    assert @teaching_request.reload.status.deleted?
    assert_redirected_to staff_manager_cancel_requests_path(anchor: "cancel_request_#{@cancel_request.id}")
  end

  test "administrative deletion without a cancellation request sends no email" do
    @cancel_request.destroy!

    assert_no_emails do
      patch staff_mark_deleted_teaching_request_path(id: @teaching_request.id)
    end

    assert @teaching_request.reload.status.deleted?
    assert_redirected_to staff_teaching_request_path(@teaching_request)
  end

  test "repeated deletion is idempotent" do
    patch staff_mark_deleted_teaching_request_path(id: @teaching_request.id)
    ActionMailer::Base.deliveries.clear

    assert_no_emails do
      patch staff_mark_deleted_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :redirect
    assert @teaching_request.reload.status.deleted?
  end

  test "staff instructor cannot delete a teaching request" do
    sign_out @manager
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    assert_no_emails do
      patch staff_mark_deleted_teaching_request_path(id: @teaching_request.id)
    end

    assert_response :forbidden
    assert @teaching_request.reload.status.assigned?
  end
end
