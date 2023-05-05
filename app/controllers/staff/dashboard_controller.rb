class Staff::DashboardController < Staff::BaseController
  def index
    if current_user
      if current_user.staff_profile.blank?
        @greetings = 'You do not have a staff account'
      elsif !current_user.staff_profile.is_approved?
        @greetings = 'Staff account request is being processed and is pending approval'
      elsif current_user.staff_profile.is_approved?
        @greetings = "#{current_user.name}: #{I18n.t(:dashboard)}"
      else
        @greetings = 'Unfortunately you do not have a staff account to use Libstar'
      end
    else
      @greetings = I18n.t 'Access Denied'
    end

    @lead_assignments = TeachingRequest.where(status: TeachingRequest.status.in_process).and(TeachingRequest.where(lead_instructor: current_user))

    @my_new_teaching_requests = current_user.teaching_requests.where(status: ['1','2','3']).where('preferred_date > ?', Date.today-1)

    @upcoming_teaching_requests = TeachingRequest.where('preferred_date BETWEEN ? AND ?', Date.today-1, Date.today+14).where(lead_instructor: current_user).or(TeachingRequest.where(second_instructor: current_user)).or(TeachingRequest.where(third_instructor: current_user)).where(status: :assigned)
    # where(lead_instructor: current_user, status: TeachingRequest.status.assigned)

    @my_teaching_requests = TeachingRequest.where(lead_instructor: current_user).or(TeachingRequest.where(second_instructor: current_user)).or(TeachingRequest.where(third_instructor: current_user)).where(status: :assigned)

    current_year = Date.today.year 
    # May 1 Current Year to April 30 Current+1
    @my_completed_teaching_requests = TeachingRequest.where('preferred_date BETWEEN ? AND ?', Date.new(current_year,5,1),Date.new(current_year+1,4,30)).where(lead_instructor: current_user).or(TeachingRequest.where(second_instructor: current_user)).or(TeachingRequest.where(third_instructor: current_user)).where(status: :done)


  end
end
