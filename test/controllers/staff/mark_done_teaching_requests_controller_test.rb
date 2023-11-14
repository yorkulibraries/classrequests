require "test_helper"

class Staff::MarkDoneTeachingRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get staff_mark_done_teaching_requests_update_url
    assert_response :success
  end
end
