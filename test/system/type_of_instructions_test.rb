require "application_system_test_case"

class TypeOfInstructionsTest < ApplicationSystemTestCase
  setup do
    @type_of_instruction = type_of_instructions(:one)
  end

  test "visiting the index" do
    visit type_of_instructions_url
    assert_selector "h1", text: "Type Of Instructions"
  end

  test "creating a Type of instruction" do
    visit type_of_instructions_url
    click_on "New Type Of Instruction"

    fill_in "Name", with: @type_of_instruction.name
    click_on "Create Type of instruction"

    assert_text "Type of instruction was successfully created"
    click_on "Back"
  end

  test "updating a Type of instruction" do
    visit type_of_instructions_url
    click_on "Edit", match: :first

    fill_in "Name", with: @type_of_instruction.name
    click_on "Update Type of instruction"

    assert_text "Type of instruction was successfully updated"
    click_on "Back"
  end

  test "destroying a Type of instruction" do
    visit type_of_instructions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Type of instruction was successfully destroyed"
  end
end
