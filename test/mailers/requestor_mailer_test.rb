require "test_helper"

class DeletemailerMailerTest < ActionMailer::TestCase
  # test "deleteme" do
  #   mail = DeletemailerMailer.deleteme
  #   assert_equal "Deleteme", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

end

class RequestorMailerTest < ActionMailer::TestCase
  setup do
    @request = FactoryBot.create(:default_teaching_request)
  end

  test "request submission confirmation renders with settings defaults" do
    mail = RequestorMailer.request_submission_confirmation(@request)

    assert_equal ["johndoe@example.com"], mail.to
    assert_equal "AUTO NOTIFICATION: Library Class Request Confirmation", mail.subject
    assert_includes mail.body.encoded, @request.first_name
    assert mail.attachments[Setting.mail_logo_url], "expected inline mail logo attachment"
  end
end