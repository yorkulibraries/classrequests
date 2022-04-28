class StaffMailer < ApplicationMailer

  def assign_instructor_for_request(request, email)
    @request = request
    @email = email
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: @email, subject: 'Class Lead Assignment: Library Class Request') do |format|
      format.html
    end

  end

  def lead_assignment_response(request, response, message, lead_name, lead_email)
    @request = request
    @lead_name = lead_name
    @response = response
    @message = message
    reply = past_tense(@response).humanize
    attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
    bootstrap_mail(to: @lead_email, subject: "Class Lead Assignment: #{reply}")

    # mail(from: lead_email, to: Setting.manager_emails, subject: "Class Lead Assignment: #{reply} ") do |format|
        # format.html
    # end

  end

end
