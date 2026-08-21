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

  def intro_library_research_notification(request)
    @request = request
    if Rails.env.development?
      emails = Setting.system_admin_emails
    else
      emails = Setting.new_request_notification
    end
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")

    # mail(to: patron_email, subject: "AUTO NOTIFICATION: Library Class Request Confirmation")
    bootstrap_mail(to: emails, subject: 'AUTO NOTIFICATION: Intro Library Research Submission')

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

  def cancel_request_notification(cancel_request)
    @cancel_request = cancel_request
    @request = cancel_request.teaching_request
    @requestor = cancel_request.user
    @message = cancel_request.reason

    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(
      to: cancellation_notification_recipients,
      subject: "Cancellation requested for class request ##{@request.id}"
    ) do |format|
      format.text
      format.html
    end
  end

  def cancel_request_completed_notification(cancel_request, processed_by)
    @cancel_request = cancel_request
    @request = cancel_request.teaching_request
    @requestor = cancel_request.user
    @processed_by = processed_by

    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(
      to: manager_notification_recipients,
      subject: "Cancellation completed for class request ##{@request.id}"
    ) do |format|
      format.text
      format.html
    end
  end

  private

  def cancellation_notification_recipients
    (Array(Setting.cancel_request_notification) + manager_notification_recipients)
      .compact
      .map(&:strip)
      .reject(&:blank?)
      .uniq
  end

  def manager_notification_recipients
    Array(Setting.manager_emails).compact.map(&:strip).reject(&:blank?).uniq
  end

end
