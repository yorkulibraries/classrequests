class SubjectPortfolioMailer < ApplicationMailer
  def assignment_notification(teaching_request)
    @request = teaching_request
    @subject_portfolio = @request.subject_portfolio

    attachments.inline[Setting.mail_logo_url] = File.read(
      Rails.root.join("app/assets/images", Setting.mail_logo_url)
    )

    bootstrap_mail(
      to: @subject_portfolio.notification_email,
      subject: "New Library Class Request: #{@subject_portfolio.name}"
    ) do |format|
      format.text
      format.html
    end
  end
end
