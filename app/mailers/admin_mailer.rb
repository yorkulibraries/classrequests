class AdminMailer < ApplicationMailer

  def request_notification(request)
    @request = request
    if Rails.env.development?
      emails = Setting.system_admin_emails
    else
      emails = Setting.new_request_notification
    end

    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: emails, subject: 'New Library Class Request') do |format|
      format.text
      format.html
    end

  end

  def new_staff_account_notification(user)
    @user = user
    emails = Setting.system_admin_emails
    mail(to: emails, subject: 'New Staff Account Request') do |format|
      format.html
    end

  end

  def error_notification(message)
    @message = message
    emails = Setting.system_admin_emails

    mail(to: emails, subject: 'ERROR: Library Class Request') do |format|
      format.text
    end

  end

  def cancel_request_notification(request, message='', requestor='')
    @request = request
    @requestor = requestor
    @message = message

    if @requestor.staff_profile.role.staff_instructor
      email_subject = "Classrequests: Staff has cancelled a class"
    else
      email_subject = "Classrequests: User has requested a class cancellation"

    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: Setting.cancel_request_notification, subject: email_subject) do |format|
      format.html
    end

  end


end
