require "application_system_test_case"

class IntroLibraryResearchesTest < ApplicationSystemTestCase

  def setup
    patron = FactoryBot.create(:valid_patron)
    login_as(patron)#,  :run_callbacks => false)
  end

  test "creating the new intro library research request by faculty" do
    visit root_url
    assert_selector "h1", text: "Library Class Request Form"
    within ("#ilr-action") do
      click_link('Introduction to Library Research')
    end
  end

  # test "should create intro library research" do
  #   click_on "New intro library research"
  #   fill_in "Academic year", with: @intro_library_research.academic_year
  #   fill_in "Course number", with: @intro_library_research.course_number
  #   fill_in "Course title", with: @intro_library_research.course_title
  #   fill_in "Email", with: @intro_library_research.email
  #   fill_in "Faculty", with: @intro_library_research.faculty
  #   fill_in "Faculty abbrev", with: @intro_library_research.faculty_abbrev
  #   fill_in "First name", with: @intro_library_research.first_name
  #   fill_in "Last name", with: @intro_library_research.last_name
  #   fill_in "Patron type", with: @intro_library_research.patron_type
  #   fill_in "Phone", with: @intro_library_research.phone
  #   fill_in "Section name or about", with: @intro_library_research.section_name_or_about
  #   fill_in "Status", with: @intro_library_research.status
  #   fill_in "Subject", with: @intro_library_research.subject
  #   fill_in "Subject abbrev", with: @intro_library_research.subject_abbrev
  #   fill_in "User", with: @intro_library_research.user_id
  #   fill_in "Username", with: @intro_library_research.username
  #   click_on "Create Intro library research"

  #   assert_text "Intro library research was successfully created"
  #   click_on "Back"
  # end

  # test "should update Intro library research" do
  #   visit intro_library_research_url(@intro_library_research)
  #   click_on "Edit this intro library research", match: :first

  #   fill_in "Academic year", with: @intro_library_research.academic_year
  #   fill_in "Course number", with: @intro_library_research.course_number
  #   fill_in "Course title", with: @intro_library_research.course_title
  #   fill_in "Email", with: @intro_library_research.email
  #   fill_in "Faculty", with: @intro_library_research.faculty
  #   fill_in "Faculty abbrev", with: @intro_library_research.faculty_abbrev
  #   fill_in "First name", with: @intro_library_research.first_name
  #   fill_in "Last name", with: @intro_library_research.last_name
  #   fill_in "Patron type", with: @intro_library_research.patron_type
  #   fill_in "Phone", with: @intro_library_research.phone
  #   fill_in "Section name or about", with: @intro_library_research.section_name_or_about
  #   fill_in "Status", with: @intro_library_research.status
  #   fill_in "Subject", with: @intro_library_research.subject
  #   fill_in "Subject abbrev", with: @intro_library_research.subject_abbrev
  #   fill_in "User", with: @intro_library_research.user_id
  #   fill_in "Username", with: @intro_library_research.username
  #   click_on "Update Intro library research"

  #   assert_text "Intro library research was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Intro library research" do
  #   visit intro_library_research_url(@intro_library_research)
  #   click_on "Destroy this intro library research", match: :first

  #   assert_text "Intro library research was successfully destroyed"
  # end
end
