require "test_helper"

class User::CancelRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @requestor = create(:user, is_active: true)
    @teaching_request = create(
      :default_teaching_request,
      user: @requestor,
      status: :assigned
    )

    ActionMailer::Base.deliveries.clear
    sign_in @requestor
  end

  test "requestor opens the cancellation form" do
    get new_user_cancel_request_path(teaching_request_id: @teaching_request.id)

    assert_response :success
    assert_includes response.body, "does not immediately cancel"
  end

  test "requestor submits a pending cancellation and managers are notified" do
    forged_user = create(:user)

    assert_difference "CancelRequest.count", 1 do
      assert_emails 1 do
        post user_cancel_requests_path, params: {
          cancel_request: {
            teaching_request_id: @teaching_request.id,
            user_id: forged_user.id,
            reason: "The course section was cancelled."
          }
        }
      end
    end

    assert_response :redirect
    cancel_request = CancelRequest.order(:created_at).last
    assert_equal @requestor, cancel_request.user
    assert_equal @teaching_request, cancel_request.teaching_request
    assert_equal "The course section was cancelled.", cancel_request.reason
    assert @teaching_request.reload.status.assigned?

    recipients = ActionMailer::Base.deliveries.last.to
    Setting.cancel_request_notification.each { |email| assert_includes recipients, email }
    Setting.manager_emails.each { |email| assert_includes recipients, email }
  end

  test "blank reason does not create a cancellation or send email" do
    assert_no_difference "CancelRequest.count" do
      assert_no_emails do
        post user_cancel_requests_path, params: {
          cancel_request: {
            teaching_request_id: @teaching_request.id,
            reason: ""
          }
        }
      end
    end

    assert_response :unprocessable_entity
    assert_select ".invalid-feedback", text: /Reason can't be blank/
  end

  test "unrelated user cannot submit a cancellation for another request" do
    sign_out @requestor
    outsider = create(:user, is_active: true)
    sign_in outsider

    assert_no_difference "CancelRequest.count" do
      assert_no_emails do
        post user_cancel_requests_path, params: {
          cancel_request: {
            teaching_request_id: @teaching_request.id,
            reason: "Forged cancellation"
          }
        }
      end
    end

    assert_response :forbidden
  end

  test "assigned instructor can submit a cancellation request" do
    sign_out @requestor
    instructor = create(:user, is_active: true)
    create(:staff_profile, user: instructor, role: :staff_instructor, is_approved: true)
    @teaching_request.update!(lead_instructor: instructor)
    sign_in instructor

    assert_difference "CancelRequest.count", 1 do
      post user_cancel_requests_path, params: {
        cancel_request: {
          teaching_request_id: @teaching_request.id,
          reason: "I am no longer available."
        }
      }
    end

    assert_response :redirect
    assert_equal instructor, CancelRequest.order(:created_at).last.user
  end

  test "unauthenticated user is redirected to sign in" do
    sign_out @requestor

    get new_user_cancel_request_path(teaching_request_id: @teaching_request.id)

    assert_redirected_to new_user_session_path
  end
end
