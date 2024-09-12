class Staff::MarkDoneTeachingRequestsController < Staff::BaseController
  before_action :set_teaching_request, only: [:update, :edit]

  def edit
  end

  def update
    respond_to do |format|
      if @teaching_request.update(teaching_request_params)
        format.html { redirect_to staff_teaching_request_path(@teaching_request), sort: @teaching_request.status.text, notice: 'Teaching Request was marked done.' }
      else
        format.html { 
          flash[:error] = "ERROR: Teaching Request mark done failed! -- #{@teaching_request.errors.full_messages.to_sentence}" 
          redirect_to staff_dashboard_path
         }
      end
    end
  end

  private

  def set_teaching_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  def teaching_request_params
    params.require(:teaching_request).permit(:status, type_of_instruction_ids: [])
  end
end
