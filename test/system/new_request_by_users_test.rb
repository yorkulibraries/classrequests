require "application_system_test_case"

class NewRequestByUsersTest < ApplicationSystemTestCase
  def setup
    patron = FactoryBot.create(:valid_patron)
    login_as(patron)#,  :run_callbacks => false)

    # FactoryBot.create_list(:institute_course, 3)
    # test_institute_course = FactoryBot.create(:valid_institute_course)
    # sign_in(@user)
  end

  test "creating the new request by faculty" do
    visit root_url
    assert_selector "h1", text: "Library Class Request Form"
    click_link('Customized, Advanced or Graduate class request')

    assert_current_path(new_user_teaching_request_path(locale: 'en'))
    # visit new_user_teaching_request_url
    assert_selector "h1", text: "New Library Class Request"

    
    # assert has_content?('John')
    # assert have_field('First Name', with: 'John')
    assert_content 'First Name'
  end

end
