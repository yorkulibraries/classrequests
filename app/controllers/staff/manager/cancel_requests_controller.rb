class Staff::Manager::CancelRequestsController < Staff::Manager::BaseController
  def index
    @cancel_requests = CancelRequest.includes(:user, :teaching_request).order(created_at: :desc)
  end
end
