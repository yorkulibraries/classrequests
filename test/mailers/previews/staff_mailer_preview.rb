# Preview all emails at http://localhost:3000/rails/mailers/deletemailer_mailer
class StaffMailerPreview < ActionMailer::Preview

  request = TeachingRequest.all.sample
  def past_tense x
    x.sub(/([^aeiouy])y$/,'\1i').sub(/([^aeiouy][aeiou])([^aeiouy])$/,'\1\2\2').sub(/e$/,'')+'ed'
  end

  def assign_instructor_for_request
    request = TeachingRequest.where.not(lead_instructor_id: nil).sample
    email = request.lead_instructor.email
    StaffMailer.assign_instructor_for_request(request, email)
  end

  # create_table "assignment_responses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  #   t.string "response"
  #   t.text "comment_or_reason"
  #   t.bigint "teaching_request_id", null: false
  #   t.bigint "user_id", null: false
  #   t.datetime "created_at", precision: 6, null: false
  #   t.datetime "updated_at", precision: 6, null: false
  #   t.index ["teaching_request_id"], name: "index_assignment_responses_on_teaching_request_id"
  #   t.index ["user_id"], name: "index_assignment_responses_on_user_id"
  #
  # def lead_assignment_response(request, response, message, lead_name, lead_email)
  #   @request = request
  #   @lead_name = lead_name
  #   @response = response
  #   @message = message
  #   reply = past_tense(@response).humanize
  #   attachments.inline["#{Setting.mail_logo_url}"] = File.read("#{Rails.root}/app/assets/images/#{Setting.mail_logo_url}")
  #   bootstrap_mail(to: Setting.manager_emails, subject: "Class Lead Assignment: #{reply}")

  def lead_assignment_response
    request = TeachingRequest.where.not(lead_instructor_id: nil).sample
    lead_email = request.lead_instructor.email
    lead_name = request.lead_instructor.first_name
    staff_response = request.assignment_responses.sample
    if !staff_response || staff_response == nil
      response = AssignmentResponse.response.accept
      message = "Yes I will do it"
    else
      response = staff_response.response
      message = staff_response.comment_or_reason
    end
    reply = past_tense(response).humanize
    StaffMailer.lead_assignment_response(request, response, message, lead_name, lead_email)
  end

end
