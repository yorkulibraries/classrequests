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

  def request_assignment(request)
    @request = request
    patron_email = @request.email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")

    # mail(to: patron_email, subject: 'AUTO NOTIFICATION: Your request has been assigned to an instructor')
    bootstrap_mail(to: patron_email, subject: 'AUTO NOTIFICATION: Your request has been assigned to an instructor')

  end

  def cancel_request_confirmation(request, requestor=nil)
    @request = request
    # if requestor && requestor != nil
    #   patron_email = requestor.email
    # else
      patron_email = @request.email
    # end
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: patron_email, subject: 'AUTO CONFIMATION: Your class request has been cancelled')

  end

end
