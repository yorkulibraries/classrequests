class Staff::MarkCancelledTeachingRequestsController < Staff::BaseController
  before_action :authorize_cancellation_manager
  before_action :set_teaching_request, only: :update

  def update
    cancel_request = @teaching_request.cancel_requests.order(created_at: :desc).first
    return redirect_without_cancellation_request unless cancel_request

    already_cancelled = false
    already_deleted = false
    cancelled = @teaching_request.with_lock do
      if @teaching_request.status&.cancelled?
        already_cancelled = true
        false
      elsif @teaching_request.status&.deleted?
        already_deleted = true
        false
      else
        @teaching_request.update_columns(
          status: TeachingRequest.status.cancelled.value,
          updated_at: Time.current
        )
      end
    end

    if cancelled
      RequestorMailer.cancel_request_confirmation(@teaching_request).deliver_now
      AdminMailer.cancel_request_completed_notification(cancel_request, current_user).deliver_now

      redirect_to staff_manager_cancel_requests_path(anchor: "cancel_request_#{cancel_request.id}"),
                  notice: 'Teaching request was marked cancelled. The requestor and managers were notified.'
    elsif already_cancelled
      redirect_to staff_manager_cancel_requests_path(anchor: "cancel_request_#{cancel_request.id}"),
                  alert: 'Teaching request was already cancelled.'
    elsif already_deleted
      redirect_to staff_manager_cancel_requests_path(anchor: "cancel_request_#{cancel_request.id}"),
                  alert: 'A deleted teaching request cannot be marked cancelled.'
    else
      redirect_to staff_manager_cancel_requests_path,
                  alert: 'Teaching request could not be marked cancelled.'
    end
  end

  private

  def authorize_cancellation_manager
    return if %w[manager director admin].include?(@access)

    head :forbidden
  end

  def set_teaching_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  def redirect_without_cancellation_request
    redirect_to staff_manager_cancel_requests_path,
                alert: 'A cancellation request is required before marking a teaching request cancelled.'
  end
end
