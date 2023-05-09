require "test_helper"

class TypeOfInstructionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @type_of_instruction = type_of_instructions(:one)
  end

  test "should get index" do
    get type_of_instructions_url
    assert_response :success
  end

  test "should get new" do
    get new_type_of_instruction_url
    assert_response :success
  end

  test "should create type_of_instruction" do
    assert_difference('TypeOfInstruction.count') do
      post type_of_instructions_url, params: { type_of_instruction: { name: @type_of_instruction.name } }
    end

    assert_redirected_to type_of_instruction_url(TypeOfInstruction.last)
  end

  test "should show type_of_instruction" do
    get type_of_instruction_url(@type_of_instruction)
    assert_response :success
  end

  test "should get edit" do
    get edit_type_of_instruction_url(@type_of_instruction)
    assert_response :success
  end

  test "should update type_of_instruction" do
    patch type_of_instruction_url(@type_of_instruction), params: { type_of_instruction: { name: @type_of_instruction.name } }
    assert_redirected_to type_of_instruction_url(@type_of_instruction)
  end

  test "should destroy type_of_instruction" do
    assert_difference('TypeOfInstruction.count', -1) do
      delete type_of_instruction_url(@type_of_instruction)
    end

    assert_redirected_to type_of_instructions_url
  end
end
