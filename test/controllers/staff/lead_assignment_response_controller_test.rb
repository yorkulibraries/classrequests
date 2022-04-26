require "test_helper"

class Staff::LeadAssignmentResponseControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get staff_lead_assignment_response_edit_url
    assert_response :success
  end

  test "should get update" do
    get staff_lead_assignment_response_update_url
    assert_response :success
  end
end
