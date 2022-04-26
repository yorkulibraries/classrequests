class User::DashboardController < User::BaseController
  def index
    @greetings = if user_signed_in?
                   "#{current_user.full_name}\'s #{I18n.t(:dashboard)}"
                 else
                   'Access Denied'
                 end

    @request_ids = current_user.requests.pluck(:id)

    #Not Submitted Requests
    @incomplete_requests = Request.where('status = ?', 0)
    @new_teaching_requests = current_user.teaching_requests.where('status = ?', 1)
    # @incomplete_sections = @incomplete_requests.sections

    #Upcoming Requests
    @upcoming_teaching_requests = current_user.teaching_requests.where('preferred_date BETWEEN ? AND ?', Date.today-1, Date.today+14).where(status: ['2','3'])

    @upcoming_sessions = Section.joins(:requests_sections).where('preferred_date BETWEEN ? AND ?', Date.today-1, Date.today+14).where('request_id IN (?)', @request_ids)

    #Past Sessions
    @past_teaching_requests = current_user.teaching_requests.where('preferred_date BETWEEN ? AND ?', Date.today-90, Date.today).where.not(status: ['0','1','2'])

    @past_sessions = Section.joins(:requests_sections).where('preferred_date BETWEEN ? AND ?', Date.today-90, Date.today).where('request_id IN (?)', @request_ids)

  end
end
