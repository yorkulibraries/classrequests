class Staff::MarkDeletedTeachingRequestsController < Staff::BaseController

  ## TODO: Move this to manager only. See how first two weeks go.

  before_action :set_teaching_request, only: :update

  def update
    @teaching_request = TeachingRequest.find(params[:id])
    # @requestor = CancelRequest.where(teaching_request: @teaching_request).first

    respond_to do |format|
      if @teaching_request.update(status: TeachingRequest.status.deleted)

        # Notify Requestor
        # if @requestor && @requestor != nil
        #   RequestorMailer.cancel_request_confirmation(@teaching_request, @requestor).deliver_now
        # else
          RequestorMailer.cancel_request_confirmation(@teaching_request).deliver_now
        # end

        format.html { redirect_to staff_teaching_request_path(@teaching_request), sort: @teaching_request.status.text, notice: 'Teaching Request was marked deleted. Faculty Notificed.' }
      else
        format.html { render :edit }
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
