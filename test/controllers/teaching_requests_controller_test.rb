require "test_helper"

class TeachingRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teaching_request = teaching_requests(:one)
  end

  test "should get index" do
    get teaching_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_teaching_request_url
    assert_response :success
  end

  test "should create teaching_request" do
    assert_difference('TeachingRequest.count') do
      post teaching_requests_url, params: { teaching_request: { academic_year: @teaching_request.academic_year, alternate_date: @teaching_request.alternate_date, alternate_time: @teaching_request.alternate_time, course_number: @teaching_request.course_number, course_title: @teaching_request.course_title, duration: @teaching_request.duration, email: @teaching_request.email, faculty: @teaching_request.faculty, faculty_abbrev: @teaching_request.faculty_abbrev, first_name: @teaching_request.first_name, instructor_notes: @teaching_request.instructor_notes, last_name: @teaching_request.last_name, lead_instructor_id: @teaching_request.lead_instructor_id, location_preference: @teaching_request.location_preference, number_of_students: @teaching_request.number_of_students, patron_type: @teaching_request.patron_type, phone: @teaching_request.phone, preferred_date: @teaching_request.preferred_date, preferred_time: @teaching_request.preferred_time, request_note: @teaching_request.request_note, second_instructor_id: @teaching_request.second_instructor_id, section_name_or_about: @teaching_request.section_name_or_about, status: @teaching_request.status, subject: @teaching_request.subject, subject_abbrev: @teaching_request.subject_abbrev, submitted_by: @teaching_request.submitted_by, submitted_on_behalf: @teaching_request.submitted_on_behalf, third_instructor_id: @teaching_request.third_instructor_id, username: @teaching_request.username } }
    end

    assert_redirected_to teaching_request_url(TeachingRequest.last)
  end

  test "should show teaching_request" do
    get teaching_request_url(@teaching_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_teaching_request_url(@teaching_request)
    assert_response :success
  end

  test "should update teaching_request" do
    patch teaching_request_url(@teaching_request), params: { teaching_request: { academic_year: @teaching_request.academic_year, alternate_date: @teaching_request.alternate_date, alternate_time: @teaching_request.alternate_time, course_number: @teaching_request.course_number, course_title: @teaching_request.course_title, duration: @teaching_request.duration, email: @teaching_request.email, faculty: @teaching_request.faculty, faculty_abbrev: @teaching_request.faculty_abbrev, first_name: @teaching_request.first_name, instructor_notes: @teaching_request.instructor_notes, last_name: @teaching_request.last_name, lead_instructor_id: @teaching_request.lead_instructor_id, location_preference: @teaching_request.location_preference, number_of_students: @teaching_request.number_of_students, patron_type: @teaching_request.patron_type, phone: @teaching_request.phone, preferred_date: @teaching_request.preferred_date, preferred_time: @teaching_request.preferred_time, request_note: @teaching_request.request_note, second_instructor_id: @teaching_request.second_instructor_id, section_name_or_about: @teaching_request.section_name_or_about, status: @teaching_request.status, subject: @teaching_request.subject, subject_abbrev: @teaching_request.subject_abbrev, submitted_by: @teaching_request.submitted_by, submitted_on_behalf: @teaching_request.submitted_on_behalf, third_instructor_id: @teaching_request.third_instructor_id, username: @teaching_request.username } }
    assert_redirected_to teaching_request_url(@teaching_request)
  end

  test "should destroy teaching_request" do
    assert_difference('TeachingRequest.count', -1) do
      delete teaching_request_url(@teaching_request)
    end

    assert_redirected_to teaching_requests_url
  end
end
