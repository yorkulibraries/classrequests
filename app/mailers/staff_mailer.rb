class StaffMailer < ApplicationMailer

  def assign_instructor_for_request(request, email)
    @request = request
    @email = email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: @email, subject: 'Class Lead Assignment: Library Class Request') do |format|
      format.html
    end

  end

  def lead_assignment_response(request, response, message, lead_name, _lead_email)
    @request = request
    @lead_name = lead_name
    @response = response
    @message = message
    reply = past_tense(@response).humanize
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: Setting.manager_emails, subject: "Class Lead Assignment: #{reply}")

    # mail(from: lead_email, to: Setting.manager_emails, subject: "Class Lead Assignment: #{reply} ") do |format|
        # format.html
    # end

  end

  def portfolio_member_assignment(request)
    @request = request
    @subject_portfolio = @request.subject_portfolio
    @assignee = @request.lead_instructor

    attachments.inline[Setting.mail_logo_url] = File.read(
      Rails.root.join('app/assets/images', Setting.mail_logo_url)
    )

    bootstrap_mail(
      to: @assignee.email,
      subject: 'Library Class Request Assigned to You'
    ) do |format|
      format.text
      format.html
    end
  end

  def portfolio_lead_confirmed(request, confirmed_by)
    @request = request
    @subject_portfolio = @request.subject_portfolio
    @assignee = @request.lead_instructor
    @confirmed_by = confirmed_by

    attachments.inline[Setting.mail_logo_url] = File.read(
      Rails.root.join('app/assets/images', Setting.mail_logo_url)
    )

    bootstrap_mail(
      to: Setting.manager_emails,
      subject: 'Library Class Request Lead Confirmed'
    ) do |format|
      format.text
      format.html
    end
  end

  def portfolio_assignment_returned(subject_portfolio_decline)
    @decline = subject_portfolio_decline
    @request = @decline.teaching_request
    @subject_portfolio = @decline.subject_portfolio
    @declined_by = @decline.declined_by

    attachments.inline[Setting.mail_logo_url] = File.read(
      Rails.root.join('app/assets/images', Setting.mail_logo_url)
    )

    bootstrap_mail(
      to: Setting.manager_emails,
      subject: 'Library Class Request Returned by Portfolio'
    ) do |format|
      format.text
      format.html
    end
  end

end
