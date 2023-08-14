class Staff::MarkUnfulfilledTeachingRequestsController < Staff::BaseController
  before_action :set_teaching_request, only: :update

  def update
    @teaching_request = TeachingRequest.find(params[:id])

    respond_to do |format|
      if @teaching_request.update(status: TeachingRequest.status.unfulfilled)
        format.html { redirect_to staff_teaching_request_path(@teaching_request), sort: @teaching_request.status.text, notice: 'Teaching Request was marked done.' }
      else
        format.html { 
          flash[:error] = "ERROR: Teaching Request mark unfulfilled failed! -- #{@teaching_request.errors.full_messages.to_sentence}" 
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
    params.permit(:status, :id)
  end
end
