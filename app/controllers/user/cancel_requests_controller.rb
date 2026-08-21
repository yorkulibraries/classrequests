class User::CancelRequestsController < User::BaseController
  before_action :set_teaching_request
  before_action :authorize_cancellation_request

  def new
    @cancel_request = @teaching_request.cancel_requests.new(user: current_user)
  end

  def create
    @cancel_request = @teaching_request.cancel_requests.new(
      cancel_request_params.merge(user: current_user)
    )

    respond_to do |format|
      if @cancel_request.save
        AdminMailer.cancel_request_notification(@cancel_request).deliver_now

        format.html do
          redirect_to operators_index_url,
                      notice: 'Cancellation request submitted for manager review.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cancel_request.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  private

  def set_teaching_request
    teaching_request_id = params[:teaching_request_id] ||
                          params.dig(:cancel_request, :teaching_request_id)
    @teaching_request = TeachingRequest.find(teaching_request_id)
  end

  def authorize_cancellation_request
    return if cancellation_request_authorized?

    head :forbidden
  end

  def cancellation_request_authorized?
    participant_ids = [
      @teaching_request.user_id,
      @teaching_request.lead_instructor_id,
      @teaching_request.second_instructor_id,
      @teaching_request.third_instructor_id
    ].compact

    participant_ids.include?(current_user.id) || manager_access?
  end

  def manager_access?
    current_user.staff_profile&.is_approved? &&
      %w[manager director administrator].include?(current_user.staff_profile.role.to_s)
  end

  def cancel_request_params
    params.require(:cancel_request).permit(:reason)
  end
end
