require "test_helper"

class AssignmentResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assignment_response = assignment_responses(:one)
  end

  test "should get index" do
    get assignment_responses_url
    assert_response :success
  end

  test "should get new" do
    get new_assignment_response_url
    assert_response :success
  end

  test "should create assignment_response" do
    assert_difference('AssignmentResponse.count') do
      post assignment_responses_url, params: { assignment_response: { comment_or_reason: @assignment_response.comment_or_reason, response: @assignment_response.response, teaching_request_id: @assignment_response.teaching_request_id, user_id: @assignment_response.user_id } }
    end

    assert_redirected_to assignment_response_url(AssignmentResponse.last)
  end

  test "should show assignment_response" do
    get assignment_response_url(@assignment_response)
    assert_response :success
  end

  test "should get edit" do
    get edit_assignment_response_url(@assignment_response)
    assert_response :success
  end

  test "should update assignment_response" do
    patch assignment_response_url(@assignment_response), params: { assignment_response: { comment_or_reason: @assignment_response.comment_or_reason, response: @assignment_response.response, teaching_request_id: @assignment_response.teaching_request_id, user_id: @assignment_response.user_id } }
    assert_redirected_to assignment_response_url(@assignment_response)
  end

  test "should destroy assignment_response" do
    assert_difference('AssignmentResponse.count', -1) do
      delete assignment_response_url(@assignment_response)
    end

    assert_redirected_to assignment_responses_url
  end
end
