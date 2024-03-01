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
      @department_staff_members = StaffProfile.includes(:user).where(department_id: params[:department])

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done]))

    when params[:start].present? && params[:end].present? && params[:status].present? && params[:department].present?
      # Case 3: Department yes, Status yes
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @department = params[:department]
      @department_name = Department.where(id: @department).pluck(:name).join(', ')
      @department_staff_members = StaffProfile.includes(:user).where(department_id: @department)

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: @department_staff_members, status: @status).or(TeachingRequest.where(second_instructor: @department_staff_members, status: @status)).or(TeachingRequest.where(third_instructor: @department_staff_members, status: @status))

    when params[:start].present? && params[:end].present? && params[:status].present? && params[:department].blank?
      # Case 4: Department no, Status yes
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @department = params[:department]

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: @status) 

    else
      # Case 5 
      flash.now[:warning] = "No Results"
      @results = {}
    end

  # case
  # when params[:start].blank? && params[:end].blank? && params[:status].blank? && params[:department].blank?
  #   logger.debug 'Params present but no values -- first if'
  #   @results = TeachingRequest.where.not(status: TeachingRequest.status.deleted) #('status != ?', TeachingRequest.status.deleted)

  # when params[:start].present? && params[:end].blank? && params[:status].blank? && params[:department].blank?
  #   # Case 1: Start is present
  #   @start_date = params[:start]
  #   logger.debug 'only start date present - elsif #1'
  #   @results = TeachingRequest.where("preferred_date > ?", @start_date).where.not(status: TeachingRequest.status.deleted) #('status != ?', TeachingRequest.status.deleted)

  # when params[:start].blank? && params[:end].present? && params[:status].blank? && params[:department].blank?
  #   # Case 2: End is present
  #   @end_date = params[:start]
  #   logger.debug 'only end date present - elsif #1'
  #   @results = TeachingRequest.where("preferred_date < ?", @end_date).where.not(status: TeachingRequest.status.deleted) #('status != ?', TeachingRequest.

  # when params[:start].blank? && params[:end].blank? && params[:status].present? && params[:department].blank?
  #   # Case 3: Status is present
  #   @status = params[:status]
  #   logger.debug 'only status present - elsif #1'
  #   @results = TeachingRequest.where(status: @status) 

  # when params[:start].blank? && params[:end].blank? && params[:status].blank? && params[:department].present?
  #   # Case 4: Department is present
  #   @department = Department.where(id: params[:department]).pluck(:name).join(', ')

  #   @department_staff_members = StaffProfile.includes(:user).where(department_id: params[:department])

  #   @results = TeachingRequest.where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done])).where.not(status: TeachingRequest.status.deleted)

  # when params[:start].present? && params[:end].present? && params[:status].present? && params[:department].present?
  #   # Case 5: All parameters are present
  #   @department = Department.where(params[:department]).pluck(:name)
  #   @department_staff_members = StaffProfile.includes(:user).where(department_id: params[:department])
  #   @start_date = params[:start]
  #   @end_date = params[:end]
    
  #   @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: @department_staff_members, status: params[:status]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: params[:status])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: params[:status])).where.not(status: params[:status])
  # else
  #   # Error: Invalid combination of parameters
  #   logger.debug 'I am in else '
  #   logger.debug 'No Results Found'
  #   @results = {}
  # end
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
