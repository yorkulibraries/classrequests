class User::CancelRequestsController < User::BaseController

  # before_action :load_teaching_request

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

  private

    def cancel_request_params
      params.require(:cancel_request).permit(:reason, :teaching_request_id, :user_id)
    end
end
