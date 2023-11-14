# require "test_helper"
#
# class StaffProfilesControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @staff_profile = staff_profiles(:one)
#   end
#
#   test "should get index" do
#     get staff_profiles_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_staff_profile_url
#     assert_response :success
#   end
#
#   test "should create staff_profile" do
#     assert_difference('StaffProfile.count') do
#       post staff_profiles_url, params: { staff_profile: { department_id: @staff_profile.department_id, is_approved: @staff_profile.is_approved, profile_bio: @staff_profile.profile_bio, role: @staff_profile.role, specializtion_job_title: @staff_profile.specializtion_job_title, user_id: @staff_profile.user_id } }
#     end
#
#     assert_redirected_to staff_profile_url(StaffProfile.last)
#   end
#
#   test "should show staff_profile" do
#     get staff_profile_url(@staff_profile)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_staff_profile_url(@staff_profile)
#     assert_response :success
#   end
#
#   test "should update staff_profile" do
#     patch staff_profile_url(@staff_profile), params: { staff_profile: { department_id: @staff_profile.department_id, is_approved: @staff_profile.is_approved, profile_bio: @staff_profile.profile_bio, role: @staff_profile.role, specializtion_job_title: @staff_profile.specializtion_job_title, user_id: @staff_profile.user_id } }
#     assert_redirected_to staff_profile_url(@staff_profile)
#   end
#
#   test "should destroy staff_profile" do
#     assert_difference('StaffProfile.count', -1) do
#       delete staff_profile_url(@staff_profile)
#     end
#
#     assert_redirected_to staff_profiles_url
#   end
# end
