require "test_helper"

class Staff::Manager::CancelRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @teaching_request = create(:default_teaching_request, status: :assigned)
    @cancel_request = CancelRequest.create!(
      teaching_request: @teaching_request,
      user: @teaching_request.user,
      reason: "The course was cancelled."
    )

    sign_in @manager
  end

  test "manager views pending cancellation requests" do
    get staff_manager_cancel_requests_path

    assert_response :success
    assert_includes response.body, "Pending manager review"
    assert_includes response.body, @cancel_request.reason
    assert_includes response.body, "Mark cancelled"
    assert_includes response.body, "Delete"
  end

  test "manager views cancelled audit records" do
    @teaching_request.update!(status: :cancelled)

    get staff_manager_cancel_requests_path

    assert_response :success
    assert_includes response.body, "Cancelled"
    assert_not_includes response.body, "Mark cancelled"
  end

  test "manager views deleted audit records separately" do
    @teaching_request.update!(status: :deleted)

    get staff_manager_cancel_requests_path

    assert_response :success
    assert_includes response.body, "Deleted"
    assert_not_includes response.body, "Mark cancelled"
  end

  test "staff instructor cannot view the manager cancellation queue" do
    sign_out @manager
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    get staff_manager_cancel_requests_path

    assert_response :forbidden
  end
end
