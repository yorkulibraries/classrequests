class RequestorMailer < ApplicationMailer

  # bootstrap_mail(
  #       to: 'to@example.com',
  #       from: 'from@example.com',
  #       subject: 'Hi From Bootstrap Email',
  #     )
  def request_submission_confirmation(request)
    @request = request
    patron_email = @request.email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")

    # mail(to: patron_email, subject: "AUTO NOTIFICATION: Library Class Request Confirmation")
    bootstrap_mail(to: patron_email, subject: 'AUTO NOTIFICATION: Library Class Request Confirmation')

  end

  def intro_library_research_submission_confirmation(request)
    @request = request
    patron_email = @request.email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")

    # mail(to: patron_email, subject: "AUTO NOTIFICATION: Library Class Request Confirmation")
    bootstrap_mail(to: patron_email, subject: 'AUTO NOTIFICATION: Intro Library Research Confirmation')

  end


  def request_assignment(request)
    @request = request
    patron_email = @request.email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")

    # mail(to: patron_email, subject: 'AUTO NOTIFICATION: Your request has been assigned to an instructor')
    bootstrap_mail(to: patron_email, subject: 'AUTO NOTIFICATION: Your request has been assigned to an instructor')

  end

  def cancel_request_confirmation(request)
    @request = request
    patron_email = @request.email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: patron_email, subject: 'Library class request cancellation confirmed') do |format|
      format.text
      format.html
    end

  end

end
