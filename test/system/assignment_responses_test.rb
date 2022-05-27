# require "application_system_test_case"
#
# class AssignmentResponsesTest < ApplicationSystemTestCase
#   setup do
#     @assignment_response = assignment_responses(:one)
#   end
#
#   test "visiting the index" do
#     visit assignment_responses_url
#     assert_selector "h1", text: "Assignment Responses"
#   end
#
#   test "creating a Assignment response" do
#     visit assignment_responses_url
#     click_on "New Assignment Response"
#
#     fill_in "Comment or reason", with: @assignment_response.comment_or_reason
#     fill_in "Response", with: @assignment_response.response
#     fill_in "Teaching request", with: @assignment_response.teaching_request_id
#     fill_in "User", with: @assignment_response.user_id
#     click_on "Create Assignment response"
#
#     assert_text "Assignment response was successfully created"
#     click_on "Back"
#   end
#
#   test "updating a Assignment response" do
#     visit assignment_responses_url
#     click_on "Edit", match: :first
#
#     fill_in "Comment or reason", with: @assignment_response.comment_or_reason
#     fill_in "Response", with: @assignment_response.response
#     fill_in "Teaching request", with: @assignment_response.teaching_request_id
#     fill_in "User", with: @assignment_response.user_id
#     click_on "Update Assignment response"
#
#     assert_text "Assignment response was successfully updated"
#     click_on "Back"
#   end
#
#   test "destroying a Assignment response" do
#     visit assignment_responses_url
#     page.accept_confirm do
#       click_on "Destroy", match: :first
#     end
#
#     assert_text "Assignment response was successfully destroyed"
#   end
# end
