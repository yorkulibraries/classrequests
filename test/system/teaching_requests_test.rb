require "application_system_test_case"
require_relative '../helpers/system_test_helper'
def fill_flatpickr_date_field(selector, value)
    page.execute_script "$('#{selector}').val('#{value}')"
end


class TeachingRequestsTest < ApplicationSystemTestCase

  include SystemTestHelper
  setup do
    # @teaching_request = teaching_requests(:one)
    # @institute_courses = FactoryBot.create_list(:institute_course, 4)
    @institute_course = FactoryBot.create(:institute_course, faculty: 'Faculty of Education', faculty_abbrev: 'ED', subject: 'Biology', subject_abbrev: 'BIOL', academic_year: '2021-2022')
    @course_one = FactoryBot.create(:first_course)
    @course_two = FactoryBot.create(:third_course)
    @course_three = FactoryBot.create(:second_course)
    @teaching_request = FactoryBot.create(:default_teaching_request)
    @patron = FactoryBot.create(:prof_john_doe)
    
  end

  test 'Make a Teaching Class Requests' do

    # Visit homepage
    # Click on Get Started
    # Login
    # Fill in request details
    # Submit
    # Verify Request

    visit root_url
    click_on 'Get Started'

    ## Should be prompted for login
    sign_in(@patron)
    assert_selector "h1", text: "New Library Class Request"

    # elements = all("css_selector")
    # elements.each do |element|
    #     puts element.text.inspect 
    # end

    
    # save_and_open_page
    ## Course Information
    # find("#teaching_request_academic_year", visible: false).find("option[value='2021-2022']").click
    # find("#teaching_request_faculty_abbrev", visible: false).find("option[value='ED - Faculty of Education']").click
    # find("#teaching_request_subject_abbrev", visible: false).find("option[value='BIOL - Biology']").click

#     <div class="card-body bg-light pt-5 pb-5">
#       <h4 class="card-title text-primary">Course Information</h4>
#       <hr class="w-50 ml-0">
#       <div class="row mt-3">
#         <div class="form-group row select required teaching_request_academic_year">
#           <label class="col-sm-3 col-form-label select required" for="teaching_request_academic_year">Academic Year <abbr title="required">*</abbr></label><div class="col-sm-9">
#           <select class="form-control select required form-select request-chosen" name="teaching_request[academic_year]" id="teaching_request_academic_year" style="display: none;">
#               <option value="">Select Academic Year</option>
#               <option value="2021-2022">2021-2022</option>
#               <option value="2022-2023">2022-2023</option>
#           </select>
#           <div class="chosen-container chosen-container-single" title="" id="teaching_request_academic_year_chosen" style="width: 100%;">
#               <a class="chosen-single">
#                   <span>Select Academic Year</span>
#                   <div><b></b></div>
#               </a>
#               <div class="chosen-drop">
#                   <div class="chosen-search">
#                       <input class="chosen-search-input" type="text" autocomplete="off">
#                   </div>
#                   <ul class="chosen-results"></ul>
#               </div>
#           </div>
#           <small class="form-text text-muted">1. Select academic year</small>
#        </div>
#      </div>

#   <!--selected: "#{Time.current.year}-#{Time.current.year+1}", -->
#       </div>

    # puts "******************************* BEFORE SELECTION *********************************"
    # puts page.body

    ## Ensure chosen dropdown loaded
    assert_selector '.chosen-container', text: 'Select Academic Year'
    assert_selector '.chosen-container', text: 'Select A Faculty'
    assert_selector '.chosen-container', text: 'Select A Department/Subject'

    select_option_value = '2021-2022'
    select_element = find('#teaching_request_academic_year_chosen')
    select_element.click
    within '.chosen-results' do
      find('li', text: select_option_value).click
    end
    # Assert that the selected option is displayed in the chosen-rails dropdown
    assert_selector '#teaching_request_academic_year_chosen .chosen-single', text: select_option_value

    
    ## Select the year
    select_option_value = '2021-2022'
    select_chosen_option('#teaching_request_academic_year_chosen', select_option_value)

    ## Select the faculty
    select_fac_option_value = 'ED - Faculty of Education'
    select_chosen_option('#teaching_request_faculty_abbrev_chosen', select_fac_option_value)
    
    ## Select the subject
    select_subj_option_value = 'BIOL'
    select_chosen_option('#teaching_request_subject_abbrev_chosen', select_subj_option_value)

    # puts "******************************* AFTER SELECTION *********************************"
    # puts page.body
    # flunk "Eject from test"

    # select 'ED - Faculty of Education', from: 'teaching_request_faculty_abbrev_chosen'
    # select 'BIOL - Biology', from: 'teaching_request_subject_abbrev_chosen'
    fill_in 'teaching_request_course_number', with: @teaching_request.course_number
    fill_in 'teaching_request_course_title', with: @teaching_request.course_title

    ## Class Preferences
    fill_in 'teaching_request_section_name_or_about', with: '50'
    fill_in 'teaching_request_number_of_students', with: @teaching_request.number_of_students
    # Find the input field and set its value using JavaScript
    # page.execute_script("document.getElementById('').value = '2023-06-30';")
    # page.execute_script("$('#teaching_request_preferred_date').flatpickr('setDate', '2023-06-30')")
    # page.execute_script("$('#teaching_request_preferred_date').setDate('2023-06-30')")
    # find("teaching_request[preferred_date]", visible: false).find("option[value='2021-2022']").click

    # Enable the field (if disabled)
    # page.execute_script("$('#teaching_request_preferred_date').prop('disabled', false)")

    # # Set the value using JavaScript
    # page.execute_script("document.getElementById('teaching_request_preferred_date').value = '2023-06-30'")


    # # Find the hidden input field associated with the datepicker
    # date_input = find('#teaching_request_preferred_date', visible: :hidden)

    # # Execute JavaScript to set the value of the hidden input field
    # page.execute_script("arguments[0].value = '2023-06-30';", date_input.native)

    # # Optional: Assert that the value was set correctly
    # assert_equal '2023-06-30', date_input.value
    # # fill_in "teaching_request[preferred_date]", with: "2023-04-22T10:00:00", visible: false

    # page.execute_script("$('#teaching_request_preferred_date')

    # .flatpickr-day today
    # Wait for the date picker table to be visible
    # date_widget_from = find('.ui-datepicker-calendar', visible: true)

    # # Find all the columns within the date picker table
    # columns = date_widget_from.all('td')

    # # Perform actions on the columns as needed
    # columns.each do |column|
    # # Perform actions on each column
    # end

    # Simulate selecting a date from the Flatpickr calendar
    select_flatpickr_date('#teaching_request_preferred_date', '26')
    
    ## Click on the input field created by flatpickr to pop calendar
    find('#teaching_request_preferred_time', visible: false).sibling('input').click
    assert_selector('.flatpickr-calendar .flatpickr-time .flatpickr-hour')
    find('.flatpickr-calendar .flatpickr-time .flatpickr-am-pm').click # to make it AM
    find('.flatpickr-calendar .flatpickr-time .flatpickr-hour').set('10') #hour
    find('.flatpickr-calendar .flatpickr-time .flatpickr-minute').set('15') #minutes
    page.send_keys(:enter)
    
    # Alternative date
    select_flatpickr_date('#teaching_request_alternate_date', '28')

    find('#teaching_request_alternate_time', visible: false).sibling('input').click
    assert_selector('.flatpickr-calendar .flatpickr-time .flatpickr-hour')
    find('.flatpickr-calendar .flatpickr-time .flatpickr-hour').set('13')
    find('.flatpickr-calendar .flatpickr-time .flatpickr-minute').set('30')
    page.send_keys(:enter)


    # puts "******************************* AFTER SELECTION *********************************"
    # puts page.body
    # fill_flatpickr_date_field('#teaching_request_preferred_date', '2023-06-30')

    page.driver.browser.manage.window.resize_to(1920, 2500)
    save_and_open_screenshot(full: true)

    # Restore the readonly attribute    


    # select_date(1.day.ago, xpath: '//*[@id="teaching_request_preferred_date"]', datepicker: :flatpickr)
    # Find the input field

    # date_input = find('#teaching_request_preferred_date')

    # # Click the input field to open the datepicker
    # date_input.click

    # # Enter the desired date value
    # date_input.send_keys('2023-06-30')

    # # Press Enter to select the date
    # date_input.send_keys(:enter)

    # # Optional: Assert that the value was set correctly
    # assert_equal '2023-06-30', date_input.value


    # Optional: Assert that the value was set correctly
    # assert_equal '2023-04-22', find('#teaching_request_preferred_date').value

    # save_and_open_screenshot


    # save_and_open_page
    flunk "Eject from test"

    # fill_in 'teaching_request_preferred_date', with: @teaching_request.preferred_date
    # fill_in 'teaching_request_preferred_time', with: @teaching_request.preferred_time
    # fill_in 'teaching_request_alternate_date', with: @teaching_request.alternate_date
    # fill_in 'teaching_request_alternate_time', with: @teaching_request.alternate_time
    fill_in 'teaching_request_duration', with: @teaching_request.duration
    fill_in 'teaching_request_location_preference', with: @teaching_request.location_preference
    fill_in 'teaching_request_room', with: 'L101B'
    fill_in 'teaching_request_request_note', with: 'Sample Note'


    click_on "Submit My Request"

    assert_text "Teaching request was successfully created"
    click_on "Back"

    # fill_in "Academic year", with: @teaching_request.academic_year

    fill_in "Email", with: @teaching_request.email
    
    fill_in "Faculty", with: @teaching_request.faculty
    fill_in "Faculty abbrev", with: @teaching_request.faculty_abbrev
    fill_in "First name", with: @teaching_request.first_name
    fill_in "Instructor notes", with: @teaching_request.instructor_notes
    fill_in "Last name", with: @teaching_request.last_name
    fill_in "Lead instructor", with: @teaching_request.lead_instructor_id
    
    

    fill_in "Patron type", with: @teaching_request.patron_type
    fill_in "Phone", with: @teaching_request.phone
    fill_in "Request note", with: @teaching_request.request_note
    fill_in "Second instructor", with: @teaching_request.second_instructor_id
    
    fill_in "Status", with: @teaching_request.status
    fill_in "Subject", with: @teaching_request.subject
    fill_in "Subject abbrev", with: @teaching_request.subject_abbrev
    fill_in "Submitted by", with: @teaching_request.submitted_by
    fill_in "Submitted on behalf", with: @teaching_request.submitted_on_behalf
    fill_in "Third instructor", with: @teaching_request.third_instructor_id
    fill_in "Username", with: @teaching_request.username
    click_on "Submit My Request"

    assert_text "Teaching request was successfully created"
    click_on "Back"

  end


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
end
