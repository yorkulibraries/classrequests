require "test_helper"

class SettingTest < ActiveSupport::TestCase
  test "provides application defaults when settings are unset" do
    assert_equal "LIBSTAR", Setting.app_name
    assert_equal "YorkULogo_Hor_186-svg.svg", Setting.logo_url
    assert_equal "YorkULogo_Hor_rgb.jpg", Setting.mail_logo_url
    assert_equal "http://localhost:3000", Setting.web_host
  end

  test "provides mail defaults when settings are unset" do
    assert_equal "Library Messenger", Setting.system_from_name
    assert_equal "noreply@library.ca", Setting.system_from_email
    assert_equal ["manager2022@mailinator.com"], Setting.manager_emails
    assert_equal ["admin2022@mailinator.com"], Setting.new_request_notification
  end
end