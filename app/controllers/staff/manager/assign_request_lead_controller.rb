class Staff::Manager::AssignRequestLeadController < ApplicationController
  def edit
    set_request
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1] }).where(is_active: true).order(:first_name)

  end

  def update
    set_request
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1] }).where(is_active: true).order(:first_name)
    @teaching_request.status = TeachingRequest.status.in_process

    respond_to do |format|

      if @teaching_request.update(teaching_request_params)
        # @lead_email = @teaching_request.lead_instructor.email

        @lead_email = @teaching_request.lead_instructor.email if @teaching_request.lead_instructor

        Rails.logger.debug "LEAD EMAIL inside response: #{@lead_email}"
        ## SEND ASSIGNED LEAD INSTRUCTOR EMAIL
        AdminMailer.assign_instructor_for_request(@teaching_request, @lead_email).deliver_now if @teaching_request.lead_instructor

        ## SEND ASSIGNED SECONDARY INSTRUCTOR EMAIL (no reponse is needed, talk to lead)
        # AdminMailer.assign_instructor_for_request(@teaching_request, @emails).deliver_now

        format.html { redirect_to staff_manager_teaching_requests_path(sort: @teaching_request.status.text), success: 'Request status was successfully updated.' }
      else
        format.html { render :edit }
        format.js {}
      end
    end
  end

  private

  def set_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def teaching_request_params
    params.require(:teaching_request).permit(:submitted_by, :status, :lead_instructor_id, :second_instructor_id, :third_instructor_id, :status)
  end

end
