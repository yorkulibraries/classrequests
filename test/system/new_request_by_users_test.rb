require "application_system_test_case"

class NewRequestByUsersTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit new_request_by_users_url
  #
  #   assert_selector "h1", text: "NewRequestByUser"
  # end

  def setup
    patron = FactoryBot.create(:valid_patron)
    login_as(patron)#,  :run_callbacks => false)

    # FactoryBot.create_list(:institute_course, 3)
    # test_institute_course = FactoryBot.create(:valid_institute_course)
  end

  test "visiting the new user request" do
    visit new_user_teaching_request_url
    assert_selector "h1", text: "New Library Class Request"
  end

end
