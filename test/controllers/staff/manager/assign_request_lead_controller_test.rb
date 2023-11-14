require "test_helper"

class Staff::Manager::AssignRequestLeadControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get staff_manager_assign_request_lead_edit_url
    assert_response :success
  end

  test "should get update" do
    get staff_manager_assign_request_lead_update_url
    assert_response :success
  end
end
