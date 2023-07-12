require 'application_system_test_case'

class HomepageTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def setup
    @patron = FactoryBot.create(:valid_patron)
    sign_in(@patron)#,  :run_callbacks => false)

    # FactoryBot.create_list(:institute_course, 3)
    # test_institute_course = FactoryBot.create(:valid_institute_course)
  end

  def teardown
    Warden.test_reset!
  end

  test "user is logged in after setup" do
    visit root_url
    # assert_text "#{assigns(:current_user).first_name} #{assigns(:current_user).last_name}'s Dashboard" 
    assert_text "Library Class Request Form"
  end
  
  # test "visit index" do
  #   visit root_url
  #   name = @patron.first_name + @patron.last_name + 's Dashboard'
  #   assert_selector "h1", text: name
  #   # http://classrequests.me.ca/en/user/teaching_requests/new
  #   # assert_selector(:css, 'a[href="/en/user/teaching_requests/new"]')
  #   find_link('Get Started')
  # end

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
