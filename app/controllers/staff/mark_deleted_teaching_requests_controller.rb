class Staff::MarkDeletedTeachingRequestsController < Staff::BaseController
  before_action :authorize_cancellation_manager
  before_action :set_teaching_request, only: :update

  def update
    cancel_request = @teaching_request.cancel_requests.order(created_at: :desc).first
    already_deleted = false
    deleted = @teaching_request.with_lock do
      if @teaching_request.status&.deleted?
        already_deleted = true
        false
      else
        @teaching_request.update_columns(
          status: TeachingRequest.status.deleted.value,
          updated_at: Time.current
        )
      end
    end

    respond_to do |format|
      if deleted
        format.html do
          redirect_to deletion_redirect_path(cancel_request),
                      notice: 'Teaching request was marked deleted. No cancellation notification was sent.'
        end
      elsif already_deleted
        format.html do
          redirect_to deletion_redirect_path(cancel_request),
                      alert: 'Teaching request was already deleted.'
        end
      else
        format.html do
          flash[:error] = 'Teaching request could not be marked deleted.'
          redirect_to staff_dashboard_path
        end
      end
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

  def deletion_redirect_path(cancel_request)
    return staff_teaching_request_path(@teaching_request) unless cancel_request

    staff_manager_cancel_requests_path(anchor: "cancel_request_#{cancel_request.id}")
  end
end
