require "test_helper"
require "minitest/mock"

class AdminMailerTest < ActionMailer::TestCase
  setup do
    @request = FactoryBot.create(:default_teaching_request)
    @cancel_request = CancelRequest.create!(
      teaching_request: @request,
      user: @request.user,
      reason: "The course has been cancelled."
    )
  end

  test "request notification renders with settings defaults" do
    mail = AdminMailer.request_notification(@request)

    assert_equal Setting.new_request_notification, mail.to
    assert_equal "New Library Class Request", mail.subject
    assert_includes mail.body.encoded, @request.first_name
    assert mail.attachments[Setting.mail_logo_url], "expected inline mail logo attachment"
  end

  test "cancellation request notifies cancellation recipients and managers" do
    Setting.stub :cancel_request_notification, ["cancellations@example.com"] do
      Setting.stub :manager_emails, ["managers@example.com"] do
        mail = AdminMailer.cancel_request_notification(@cancel_request)

        assert_equal ["cancellations@example.com", "managers@example.com"], mail.to
        assert_equal "Cancellation requested for class request ##{@request.id}", mail.subject
        assert_includes mail.text_part.body.decoded, "still active"
        assert_includes mail.text_part.body.decoded, @cancel_request.reason
      end
    end
  end

  test "completed cancellation notifies managers" do
    processed_by = create(:user)

    Setting.stub :manager_emails, ["managers@example.com"] do
      mail = AdminMailer.cancel_request_completed_notification(@cancel_request, processed_by)

      assert_equal ["managers@example.com"], mail.to
      assert_equal "Cancellation completed for class request ##{@request.id}", mail.subject
      assert_includes mail.text_part.body.decoded, processed_by.name
      assert_includes mail.text_part.body.decoded, @request.user.name
    end
  end
end
