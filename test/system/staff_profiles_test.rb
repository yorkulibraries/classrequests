# require "application_system_test_case"
#
# class StaffProfilesTest < ApplicationSystemTestCase
#   setup do
#     @staff_profile = staff_profiles(:one)
#   end
#
#   test "visiting the index" do
#     visit staff_profiles_url
#     assert_selector "h1", text: "Staff Profiles"
#   end
#
#   test "creating a Staff profile" do
#     visit staff_profiles_url
#     click_on "New Staff Profile"
#
#     fill_in "Department", with: @staff_profile.department_id
#     check "Is approved" if @staff_profile.is_approved
#     fill_in "Profile bio", with: @staff_profile.profile_bio
#     fill_in "Role", with: @staff_profile.role
#     fill_in "Specializtion job title", with: @staff_profile.specializtion_job_title
#     fill_in "User", with: @staff_profile.user_id
#     click_on "Create Staff profile"
#
#     assert_text "Staff profile was successfully created"
#     click_on "Back"
#   end
#
#   test "updating a Staff profile" do
#     visit staff_profiles_url
#     click_on "Edit", match: :first
#
#     fill_in "Department", with: @staff_profile.department_id
#     check "Is approved" if @staff_profile.is_approved
#     fill_in "Profile bio", with: @staff_profile.profile_bio
#     fill_in "Role", with: @staff_profile.role
#     fill_in "Specializtion job title", with: @staff_profile.specializtion_job_title
#     fill_in "User", with: @staff_profile.user_id
#     click_on "Update Staff profile"
#
#     assert_text "Staff profile was successfully updated"
#     click_on "Back"
#   end
#
#   test "destroying a Staff profile" do
#     visit staff_profiles_url
#     page.accept_confirm do
#       click_on "Destroy", match: :first
#     end
#
#     assert_text "Staff profile was successfully destroyed"
#   end
# end
