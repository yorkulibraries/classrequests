class Staff::Manager::DashboardController < Staff::Manager::BaseController
  def index
    # @request_ids = Request.pluck(:id)
    # @upcoming_sessions = Section.joins(:requests_sections).where('preferred_date BETWEEN ? AND ?', Date.today-1, Date.today+14).where('request_id IN (?)', @request_ids)

    @greetings = if user_signed_in?
                   "#{current_user.full_name}'s dashboard"
                 else
                   I18n.t 'Access Denied'
                 end


    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1]}).where(is_active: true).order(:first_name)

    @pending_approvals = StaffProfile.where('is_approved = ?', false) #.where('is_active = ?', false)
    @inactive_users = User.where('is_active = ?', false)

    @lead_assignments = TeachingRequest.where(status: TeachingRequest.status.in_process).and(TeachingRequest.where(lead_instructor: current_user))
    @my_teaching_requests = TeachingRequest.where(lead_instructor: current_user).order(:created_at)

    @new_teaching_requests = TeachingRequest.where('status = ?', 1)
    #Upcoming Requests
    @upcoming_teaching_requests = TeachingRequest.where('preferred_date BETWEEN ? AND ?', Date.today-1, Date.today+14).where(status: :assigned)

  end
end
