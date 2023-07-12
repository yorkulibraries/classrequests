require 'application_system_test_case'

class UserDashboardTest < ApplicationSystemTestCase

  def setup
    @patron = FactoryBot.create(:valid_patron)
    # login_as(patron)#,  :run_callbacks => false)
    sign_in(@patron)#,  :run_callbacks => false)
  end

  def teardown
    Warden.test_reset!
  end

  test 'user dashboard' do
    visit root_url
    # click_on 'My Dashboard'
    # assert_text "#{assigns(:current_user).first_name} #{assigns(:current_user).last_name}'s Dashboard" 
  end

  

end
