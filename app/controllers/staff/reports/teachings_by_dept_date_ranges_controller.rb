class Staff::Reports::TeachingsByDeptDateRangesController < Staff::BaseController
  layout 'staff/base'

  def index

    logger.debug '*************** REPORTS ************** '
    logger.debug "Start: #{params[:start]}"
    logger.debug "End: #{params[:end]}"
    logger.debug "Status: #{params[:status]}"
    logger.debug "Department: #{params[:department]}"

    case
    when (params[:start].blank? && params[:end].blank? && params[:status].blank? && params[:department].blank?) || (params[:start].blank? || params[:end].blank?)
      # Case 1: Missing Start/End Dates or all blank
      flash.now[:error] = "Start date and end date are required fields."
      render action: "index"
      return
    when params[:start].present? && params[:end].present? && params[:status].blank? && params[:department].blank?
      # Case 1: Only Dates
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @department = params[:department]

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: [:assigned, :done]) 

    when params[:start].present? && params[:end].present? && params[:status].blank? && params[:department].present?
      # Case 2: Department yes, Status no
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @department = params[:department]
      @department_name = Department.where(id: params[:department]).pluck(:name).join(', ')
      # @department_staff_members = StaffProfile.includes(:user).where(department_id: params[:department])
      # @department_staff_members = User.joins(:staff_profile).where(staff_profiles: { department_id: params[:department] })
      @department_staff_members = User.joins(:staff_profile).where(staff_profiles: { department_id: params[:department] }).pluck(:id)


      # @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done]))

      @results = TeachingRequest.where(status: [3,4])
                                .where(preferred_date: @start_date..@end_date)
                                .where('lead_instructor_id IN (?) OR second_instructor_id IN (?) OR third_instructor_id IN (?)', @department_staff_members, @department_staff_members, @department_staff_members)

    when params[:start].present? && params[:end].present? && params[:status].present? && params[:department].present?
      # Case 3: Department yes, Status yes
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @department = params[:department]
      @department_name = Department.where(id: @department).pluck(:name).join(', ')
      # @department_staff_members = User.joins(:staff_profile).where(staff_profiles: { department_id: params[:department] })
      @department_staff_members = User.joins(:staff_profile).where(staff_profiles: { department_id: params[:department] }).pluck(:id)


      # @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: @department_staff_members, status: @status).or(TeachingRequest.where(second_instructor: @department_staff_members, status: @status)).or(TeachingRequest.where(third_instructor: @department_staff_members, status: @status))
      
      @results = TeachingRequest.where(status: 4)
                                .where(preferred_date: @start_date..@end_date)
                                .where('lead_instructor_id IN (?) OR second_instructor_id IN (?) OR third_instructor_id IN (?)', @department_staff_members, @department_staff_members, @department_staff_members)

    when params[:start].present? && params[:end].present? && params[:status].present? && params[:department].blank?
      # Case 4: Department no, Status yes
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @department = params[:department]

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: @status) 
      # SELECT `teaching_requests`.* FROM `teaching_requests` WHERE `teaching_requests`.`preferred_date` BETWEEN '2024-03-01' AND '2024-04-02' AND `teaching_requests`.`status` = 4

    else
      # Case 5 
      flash.now[:warning] = "No Results"
      @results = {}
    end
    
    respond_to do |format|
      format.html
      # format.csv { send_data @results.to_csv }
      format.xlsx { 
        today = Date.today.to_s
        response.headers['Content-Disposition'] = "attachment; filename=\"#{today}_teachings_by_dept_date.xlsx\""
      }
    end
  end


  def new
  end

  def create
    if params[:teachings_by_dept_date_ranges]
      @start_date = params[:teachings_by_dept_date_ranges][:start_date]
      @end_date = params[:teachings_by_dept_date_ranges][:end_date]
      @status = params[:teachings_by_dept_date_ranges][:status]
      @department = params[:teachings_by_dept_date_ranges][:department]
      respond_to do |format|
        format.html {
          redirect_to staff_reports_teachings_by_dept_date_ranges_path(start: @start_date, end: @end_date, status: @status, department: @department)
        }
      end
    end
  end
end
