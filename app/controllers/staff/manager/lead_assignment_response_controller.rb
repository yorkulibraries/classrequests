class Staff::Manager::LeadAssignmentResponseController < ApplicationController
  def edit
    set_request
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1] }).where(is_active: true).order(:first_name)

  end

  def update
    set_request
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1]}).where(is_active: true).order(:first_name)

    @teaching_request.status = TeachingRequest.status.assigned

    respond_to do |format|
      if @teaching_request.update(teaching_request_params)
        format.html { redirect_to staff_manager_dashboard_path(sort: @teaching_request.status.text), success: 'Request status was successfully updated.' }
      else
        format.html { render :edit }
        format.js {}
        # format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def teaching_request_params
    params.require(:teaching_request).permit(:submitted_by, :status, :lead_instructor_id, :second_instructor_id, :third_instructor_id, :status, :lead_assignment_response)

    # {section_ids: [:id, :status]}
  end

end
