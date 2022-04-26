require 'application_system_test_case'

class UserDashboardTest < ApplicationSystemTestCase

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

  test 'sign up' do
    visit root_url
    click_on 'public-account-navbar-dropdown'
    click_on 'Logout'
    click_on 'Sign Up'
    assert_selector 'h1', text: 'Sign Up'
    fill_in 'Username', with: 'testuser1'
    select 'Staff', from: 'user_user_group'
    select 'YorkU Instructor', from: 'user_iam_identification'
    fill_in 'Email Address', with: 'testuser1@mailinator.com'
    fill_in 'Password', with:'testuser1'
    fill_in 'Confirm Password', with:'testuser1'
    fill_in 'First Name', with:'test'
    fill_in 'Last Name', with:'user1'
    fill_in 'Phone', with:'416-555-4444'
    fill_in 'Alternate Email', with: 'testuser1.alt@mailinator.com'
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

  test "submit a request" do
    visit user_request_url

  end

end
