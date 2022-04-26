# Preview all emails at http://localhost:3000/rails/mailers/deletemailer_mailer
class StaffMailerPreview < ActionMailer::Preview

  request = TeachingRequest.all.sample

  def assign_instructor_for_request
    request = TeachingRequest.where.not(lead_instructor_id: nil).sample
    email = request.lead_instructor.email
    StaffMailer.assign_instructor_for_request(request, email)
  end

  def lead_assignment_response
    request = TeachingRequest.where.not(lead_instructor_id: nil).sample
    lead_email = request.lead_instructor.email
    lead_name = request.lead_instructor.first_name
    response = request.assignment_request.response
    message = request.assignment_request.message
    reply = past_tense(@response).humanize
    StaffMailer.lead_assignment_response(request, response, message, lead_name, lead_email)
  end

end
