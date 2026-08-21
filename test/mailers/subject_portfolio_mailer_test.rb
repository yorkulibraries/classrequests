require "test_helper"

class SubjectPortfolioMailerTest < ActionMailer::TestCase
  setup do
    @subject_portfolio = create(
      :subject_portfolio,
      name: "Humanities",
      notification_email: "humanities@example.com"
    )
    @request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: @subject_portfolio,
      lead_instructor: nil
    )
  end

  test "assignment notification uses the portfolio address and request details" do
    mail = SubjectPortfolioMailer.assignment_notification(@request)

    assert_equal [@subject_portfolio.notification_email], mail.to
    assert_equal "New Library Class Request: Humanities", mail.subject
    assert_includes mail.html_part.body.encoded, @subject_portfolio.name
    assert_includes mail.html_part.body.encoded, @request.email
    assert_includes mail.text_part.body.encoded, @request.course_number.to_s
    assert mail.attachments[Setting.mail_logo_url], "expected inline mail logo attachment"
  end
end
