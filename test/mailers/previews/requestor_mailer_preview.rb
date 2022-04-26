# Preview all emails at http://localhost:3000/rails/mailers/deletemailer_mailer
class RequestorMailerPreview < ActionMailer::Preview
  # extend Enumerize

  # Preview this email at http://localhost:3000/rails/mailers/deletemailer_mailer/deleteme
  def request_submission_confirmation
    request = TeachingRequest.last
    RequestorMailer.request_submission_confirmation(request)
  end

  def request_assignment
    request = TeachingRequest.where(status: :in_process).where.not(lead_instructor_id: nil).sample
    RequestorMailer.request_assignment(request)
  end

  def cancel_request_confirmation

    cancel_request = CancelRequest.where.not(user: nil).sample
    requestor = User.find(cancel_request.user.id)
    request = cancel_request.teaching_request
    patron_email = requestor.email
    RequestorMailer.cancel_request_confirmation(request, requestor)

  end
end
