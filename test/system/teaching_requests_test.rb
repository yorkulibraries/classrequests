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
    @institute_course = FactoryBot.create(:institute_course, faculty: 'Faculty of Education', faculty_abbrev: 'ED', subject: 'Biology', subject_abbrev: 'BIOL', academic_year: '2022-2023', academic_term: "Fall/Winter")
    @course_one = FactoryBot.create(:first_course)
    @course_two = FactoryBot.create(:second_course)
    @course_three = FactoryBot.create(:third_course)
    @teaching_request = FactoryBot.create(:default_teaching_request)
    @patron = FactoryBot.create(:prof_john_doe)
  end

  teardown do
    @institute_course.destroy
    @course_one.destroy
    @course_two.destroy
    @course_three.destroy
    @teaching_request.destroy
    @patron.destroy
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
    click_on 'Request a Class'
    assert_selector "h1", text: "New Library Class Request"

    # find("#teaching_request_academic_year_chosen", visible: false).find("option[value='2022-2023']").click
    # find("#teaching_request_faculty_abbrev", visible: false).find("option[value='ED - Faculty of Education']").click
    # find("#teaching_request_subject_abbrev", visible: false).find("option[value='BIOL - Biology']").click

    assert_selector '#teaching_request_academic_term_chosen'

    select_element = find('#teaching_request_academic_term_chosen')
    select_element.click
    within '.chosen-results' do
      find('li', text: "Fall/Winter").click
    end

    assert_selector '#teaching_request_academic_term_chosen .chosen-single', text: "Fall/Winter"

    
    assert_selector '#teaching_request_academic_year_chosen'
  
    select_option_value = '2022-2023'
    select_element = find('#teaching_request_academic_year_chosen')
    select_element.click
    within '.chosen-results' do
      find('li', text: select_option_value).click
    end
    # Assert that the selected option is displayed in the chosen-rails dropdown
    assert_selector '#teaching_request_academic_year_chosen .chosen-single', text: select_option_value

    
    ## Select the year
    select_year_option_value = '2022-2023'
    select_chosen_option('#teaching_request_academic_year_chosen', select_year_option_value)

    ## Select the faculty
    select_fac_option_value = 'ED - Faculty of Education'
    select_chosen_option('#teaching_request_faculty_abbrev_chosen', select_fac_option_value)
    
    ## Select the subject
    select_subj_option_value = 'BIOL'
    select_chosen_option('#teaching_request_subject_abbrev_chosen', select_subj_option_value)

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
    select_flatpickr_date('#teaching_request_preferred_date', '28')
    ## Click on the input field created by flatpickr to pop calendar
    find('#teaching_request_preferred_time', visible: false).sibling('input').click
    assert_selector('.flatpickr-calendar .flatpickr-time .flatpickr-hour')
    find('.flatpickr-calendar .flatpickr-time .flatpickr-am-pm').click # to make it AM
    find('.flatpickr-calendar .flatpickr-time .flatpickr-hour').set('10') #hour
    find('.flatpickr-calendar .flatpickr-time .flatpickr-minute').set('15') #minutes
    page.send_keys(:enter)
    
    # Alternative date
    select_flatpickr_date('#teaching_request_alternate_date', '30')
    find('#teaching_request_alternate_time', visible: false).sibling('input').click
    assert_selector('.flatpickr-calendar .flatpickr-time .flatpickr-hour')
    find('.flatpickr-calendar .flatpickr-time .flatpickr-hour').set('13')
    find('.flatpickr-calendar .flatpickr-time .flatpickr-minute').set('30')
    page.send_keys(:enter)

    select_duration_option_value = '60 minutes'
    select_chosen_option('#teaching_request_duration_chosen', select_duration_option_value)

    # fill_in 'teaching_request_location_preference', with: @teaching_request.location_preference
    choose('To be determined', allow_label_click: true)
    fill_in 'teaching_request_room', with: 'L101B'

    # Find the Trix editor textarea
    request_note = find("#teaching_request_request_note")

    # Use Capybara's set method to fill in the content
    request_note.set('Sample Test Note')

    # fill_in 'teaching_request_request_note', with: 'Sample Test Note'

    click_on "Submit My Request"

    sleep(2) # 2 seconds
    click_on 'Confirm'

    # Quit current window
    Capybara.current_session.quit


    ## CONFIRM IT WAS ADDED
    sign_in(@patron)
    visit root_url
    click_on 'My Dashboard'
    assert_text "#{@patron.first_name} #{@patron.last_name}"

    assert_text "Your Teaching Requests"

    @tr = TeachingRequest.last
    puts "#{@tr.name}[#{@tr.number_of_students} Students]"
    # assert_text "#{@tr.name}[#{@tr.number_of_students} Students]"
    assert_text "#{@tr.name}"

  end

  ## UPDATE REQUEST

  ## DESTROY REQUEST

  
end
