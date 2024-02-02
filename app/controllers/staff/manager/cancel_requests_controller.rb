## TODO:
# Not yet implemented. In-progress.

class Staff::Manager::CancelRequestsController < Staff::Manager::BaseController
  before_action :set_cancel_request, only: %i[ show edit update destroy ]

  def index 
    @cancel_requests = CancelRequest.all
  end

  def new
    @cancel_request = CancelRequest.new
    @teaching_request = TeachingRequest.find(params[:teaching_request_id])
  end

  def create

    @cancel_request = CancelRequest.new(cancel_request_params)

    # @teaching_request = CancelRequest.teaching_request
    @teaching_request = TeachingRequest.find(params[:cancel_request][:teaching_request_id])
    @requestor = User.find(params[:cancel_request][:user_id])

    respond_to do |format|
      if @cancel_request.save

        ## SEND ASSIGNED LEAD INSTRUCTOR EMAIL
        if @cancel_request.reason && @cancel_request.reason != '' && @cancel_request.reason != nil
          message = @cancel_request.reason
        else
          message = 'No comment / reason given'
        end

        AdminMailer.cancel_request_notification(@teaching_request, message, @requestor).deliver_now

        format.html { redirect_to operators_index_url, danger: 'Cancel Request Submitted' }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cancel_request.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @cancel_request.destroy
        format.html { redirect_to staff_manager_cancel_requests_path, notice: 'Cancel Request was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to staff_manager_cancel_requests_path, notice: 'Cancel Request could not be deleted.' }
        format.json { render json: @cancel_request.errors, status: :unprocessable_entity }
      end
    end
  end



  private

    # def cancel_request_params
    #   params.require(:cancel_request).permit(:reason, :teaching_request_id, :user_id)
    # end

    # def load_teaching_request
    #   @teaching_request = TeachingRequest.find(params[:teaching_request_id])
    # end

    def set_cancel_request
      @cancel_request = CancelRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cancel_request_params
      params.require(:cancel_request).permit(:reason, :teaching_request_id, :user_id, teaching_request_attributes: [:id, :status] )
      # params.require(:cancel_request).permit(:reason )
    end

end
