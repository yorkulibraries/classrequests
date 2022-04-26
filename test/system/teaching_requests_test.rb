# require "application_system_test_case"
#
# class TeachingRequestsTest < ApplicationSystemTestCase
#   setup do
#     @teaching_request = teaching_requests(:one)
#   end
#
#   test "visiting the index" do
#     visit teaching_requests_url
#     assert_selector "h1", text: "Teaching Requests"
#   end
#
#   test "creating a Teaching request" do
#     visit teaching_requests_url
#     click_on "New Teaching Request"
#
#     fill_in "Academic year", with: @teaching_request.academic_year
#     fill_in "Alternate date", with: @teaching_request.alternate_date
#     fill_in "Alternate time", with: @teaching_request.alternate_time
#     fill_in "Course number", with: @teaching_request.course_number
#     fill_in "Course title", with: @teaching_request.course_title
#     fill_in "Duration", with: @teaching_request.duration
#     fill_in "Email", with: @teaching_request.email
#     fill_in "Faculty", with: @teaching_request.faculty
#     fill_in "Faculty abbrev", with: @teaching_request.faculty_abbrev
#     fill_in "First name", with: @teaching_request.first_name
#     fill_in "Instructor notes", with: @teaching_request.instructor_notes
#     fill_in "Last name", with: @teaching_request.last_name
#     fill_in "Lead instructor", with: @teaching_request.lead_instructor_id
#     fill_in "Location preference", with: @teaching_request.location_preference
#     fill_in "Number of students", with: @teaching_request.number_of_students
#     fill_in "Patron type", with: @teaching_request.patron_type
#     fill_in "Phone", with: @teaching_request.phone
#     fill_in "Preferred date", with: @teaching_request.preferred_date
#     fill_in "Preferred time", with: @teaching_request.preferred_time
#     fill_in "Request note", with: @teaching_request.request_note
#     fill_in "Second instructor", with: @teaching_request.second_instructor_id
#     fill_in "Section name or about", with: @teaching_request.section_name_or_about
#     fill_in "Status", with: @teaching_request.status
#     fill_in "Subject", with: @teaching_request.subject
#     fill_in "Subject abbrev", with: @teaching_request.subject_abbrev
#     fill_in "Submitted by", with: @teaching_request.submitted_by
#     fill_in "Submitted on behalf", with: @teaching_request.submitted_on_behalf
#     fill_in "Third instructor", with: @teaching_request.third_instructor_id
#     fill_in "Username", with: @teaching_request.username
#     click_on "Create Teaching request"
#
#     assert_text "Teaching request was successfully created"
#     click_on "Back"
#   end
#
#   test "updating a Teaching request" do
#     visit teaching_requests_url
#     click_on "Edit", match: :first
#
#     fill_in "Academic year", with: @teaching_request.academic_year
#     fill_in "Alternate date", with: @teaching_request.alternate_date
#     fill_in "Alternate time", with: @teaching_request.alternate_time
#     fill_in "Course number", with: @teaching_request.course_number
#     fill_in "Course title", with: @teaching_request.course_title
#     fill_in "Duration", with: @teaching_request.duration
#     fill_in "Email", with: @teaching_request.email
#     fill_in "Faculty", with: @teaching_request.faculty
#     fill_in "Faculty abbrev", with: @teaching_request.faculty_abbrev
#     fill_in "First name", with: @teaching_request.first_name
#     fill_in "Instructor notes", with: @teaching_request.instructor_notes
#     fill_in "Last name", with: @teaching_request.last_name
#     fill_in "Lead instructor", with: @teaching_request.lead_instructor_id
#     fill_in "Location preference", with: @teaching_request.location_preference
#     fill_in "Number of students", with: @teaching_request.number_of_students
#     fill_in "Patron type", with: @teaching_request.patron_type
#     fill_in "Phone", with: @teaching_request.phone
#     fill_in "Preferred date", with: @teaching_request.preferred_date
#     fill_in "Preferred time", with: @teaching_request.preferred_time
#     fill_in "Request note", with: @teaching_request.request_note
#     fill_in "Second instructor", with: @teaching_request.second_instructor_id
#     fill_in "Section name or about", with: @teaching_request.section_name_or_about
#     fill_in "Status", with: @teaching_request.status
#     fill_in "Subject", with: @teaching_request.subject
#     fill_in "Subject abbrev", with: @teaching_request.subject_abbrev
#     fill_in "Submitted by", with: @teaching_request.submitted_by
#     fill_in "Submitted on behalf", with: @teaching_request.submitted_on_behalf
#     fill_in "Third instructor", with: @teaching_request.third_instructor_id
#     fill_in "Username", with: @teaching_request.username
#     click_on "Update Teaching request"
#
#     assert_text "Teaching request was successfully updated"
#     click_on "Back"
#   end
#
#   test "destroying a Teaching request" do
#     visit teaching_requests_url
#     page.accept_confirm do
#       click_on "Destroy", match: :first
#     end
#
#     assert_text "Teaching request was successfully destroyed"
#   end
# end
