# Preview all emails at http://localhost:3000/rails/mailers/deletemailer_mailer
class AdminMailerPreview < ActionMailer::Preview

  request = TeachingRequest.all.sample
  # Preview this email at http://localhost:3000/rails/mailers/MailerModel/MailerAction
  def request_notification
    request = TeachingRequest.where(status: :new_request).sample
    AdminMailer.request_notification(request)
  end

  # def new_staff_account_notification
  #   staff_profiles = StaffProfile.select(:user_id).where(is_approved: false)
  #   user = User.where(id: staff_profiles)
  #   AdminMailer.new_staff_account_notification(user)
  # end

  def assign_instructor_for_request
    request = TeachingRequest.where.not(lead_instructor_id: nil).sample
    email = request.lead_instructor.email
    AdminMailer.assign_instructor_for_request(request, email)
  end


  def cancel_request_notification

    cancel_request = CancelRequest.where.not(user: nil).sample
    requestor = User.find(cancel_request.user.id)
    request = cancel_request.teaching_request
    patron_email = requestor.email
    message = (cancel_request.reason != nil) ? cancel_request.reason : "Did not leave a comment"
    AdminMailer.cancel_request_notification(request, message, requestor)

  end

  # def error_notification(message)
  #
  # end
  # def cancel_request_notification
  #   message =""
  #   requestor=""
  #   AdminMailer.cancel_request_notification(request, message, requestor)
  # end



end
