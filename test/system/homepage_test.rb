require 'application_system_test_case'

class HomepageTest < ApplicationSystemTestCase

  def setup
    patron = FactoryBot.create(:valid_patron)
    login_as(patron)#,  :run_callbacks => false)

    # FactoryBot.create_list(:institute_course, 3)
    # test_institute_course = FactoryBot.create(:valid_institute_course)
  end

  def teardown
    Warden.test_reset!
  end

  test "visit index" do
    visit root_url
    assert_selector "h1", text: "Library Class Request Form"
  end

  # test 'sign_in_user' do
  #   visit root_url
  #   click_on 'Login'
  #   fill_in 'Email Address', with: 'testuser1@mailinator.com'
  #   fill_in 'Password', with:'testuser1'
  #   # print response.body
  #
  #   click_on 'Log in'
  #
  #   # assert has_content?("Welcome")
  #   # save_and_open_page
  #   # assert_select "title", "Welcome test user1 to your dashboard"
  #
  #   # assert_selector "h1", text: "Welcome"
  # end
  # sign_in users(:regular)

end
