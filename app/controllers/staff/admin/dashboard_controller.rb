class Staff::Admin::DashboardController < Staff::Admin::BaseController
  def index

    @pending_approvals = StaffProfile.where('is_approved = ?', false)

  end
end
