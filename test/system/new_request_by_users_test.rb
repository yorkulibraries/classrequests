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
    # sign_in(@user)
  end

  test "creating the new request by faculty" do
    visit root_url
    assert_selector "h1", text: "Library Class Request Form"
    click_link('Get Started')

    assert_current_path(new_user_teaching_request_path(locale: 'en'))
    # visit new_user_teaching_request_url
    assert_selector "h1", text: "New Library Class Request"

    
    # assert has_content?('John')
    # assert have_field('First Name', with: 'John')
    assert_has_content 'First Name'
  end

  

  # factory :valid_patron, class: User do
  #   email { "facultyrequestor@mailinator.com" }
  #   username {"faculty-requestor"}
  #   password { Faker::Internet.password }
  #   first_name {"John"}
  #   last_name {Faker::Name.last_name}
  #   contact_phone {"416-222-2345"}
  #   is_active { true}
  #   is_verified { false}
  #   user_uid { 111222333}
  #   alternate_email { Faker::Internet.email}
  #   user_source { "db"}
  #   user_group { "Faculty"}
  #   iam_identification { "YorkU Instructor"}
  #   note { Faker::Lorem.paragraph(sentence_count: 2)}


end
