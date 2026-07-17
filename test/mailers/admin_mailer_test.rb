require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  setup do
    @request = FactoryBot.create(:default_teaching_request)
  end

  test "request notification renders with settings defaults" do
    mail = AdminMailer.request_notification(@request)

    assert_equal Setting.new_request_notification, mail.to
    assert_equal "New Library Class Request", mail.subject
    assert_includes mail.body.encoded, @request.first_name
    assert mail.attachments[Setting.mail_logo_url], "expected inline mail logo attachment"
  end
end