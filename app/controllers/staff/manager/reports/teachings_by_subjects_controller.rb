class Staff::Manager::Reports::TeachingsBySubjectsController < ApplicationController
  layout 'staff/manager/base'

  def index
    logger.debug '*************** REPORTS ************** '
    logger.debug "Start: #{params[:start]}"
    logger.debug "End: #{params[:end]}"
    logger.debug "Status: #{params[:status]}"
    logger.debug "Department: #{params[:subject]}"

    case
    when (params[:start].blank? && params[:end].blank? && params[:status].blank? && params[:department].blank?) || (params[:start].blank? || params[:end].blank?)
      # Case 1: Missing Start/End Dates or all blank
      flash.now[:error] = "Start date and end date are required fields."
      render action: "index"
      return

    # Case 1: Only Dates
    when params[:start].present? && params[:end].present? && params[:status].blank? && params[:subject].blank?
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @subject = params[:subject]

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: [:assigned, :done]) 
    # Case 2: Subject yes, Status no
    when params[:start].present? && params[:end].present? && params[:status].blank? && params[:subject].present?
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @subject= params[:subject]
      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(subject: @subject).where.not(status: TeachingRequest.status.deleted)
      # @department_name = Department.where(id: params[:department]).pluck(:name).join(', ')
      # @department_staff_members = StaffProfile.includes(:user).where(department_id: params[:department])

    # Case 3: Subject yes, Status yes
    # Case 4: Subject no, Status yes
    else
      # Case 5 
      flash.now[:warning] = "No Results"
      @results = {}
    end

    # if (params[:start] && params[:end] && params[:status]) && (params[:start] == '' || params[:end] == '') && (params[:status] = '')

    #   logger.debug 'Params present but no values -- first if'
    #   @results = TeachingRequest.where.not(status: TeachingRequest.status.deleted) #('status != ?', TeachingRequest.status.deleted)


    # elsif (params[:start] && params[:end]) && (params[:start] != '' && params[:end] != '') && (!params[:status] || params[:status] == '')

    #   logger.debug 'No Status Provided -- I am in elsif #1'
    #   @start_date = params[:start]
    #   @end_date = params[:end]

    #   # @results = TeachingRequest.where('preferred_date BETWEEN ? AND ? AND status != ?', @start_date, @end_date, TeachingRequest.status.deleted)
    #   @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where.not(status: TeachingRequest.status.deleted)

    #   # .where(Section.where.not(status: Section::UNFULFILLED)
    # elsif (params[:start] && params[:end] && params[:status]) && (params[:start] != '' && params[:end] != '' && params[:status] != '')
    #   logger.debug 'All three provided -- I am in elsif #2'

    #   @start_date = params[:start]
    #   @end_date = params[:end]
    #   @status = params[:status]

    #   # status_value = TeachingRequest.status.find_value(@status).value
    #   # @results = TeachingRequest.where('preferred_date BETWEEN ? AND ? AND status = ?', @start_date, @end_date, @status)
    #   @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: @status)

    # else
    #   logger.debug 'No Results Found or Invalid Dates/Status -- in else'
    #   @results = {}

    # end
    respond_to do |format|
      format.html
      # format.csv { send_data @results.to_csv }
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"#{@start_date}_teachings_by_date_and_subject.xlsx\""}
    end

  end

  def new
    @subjects_list = TeachingRequest.all.pluck(:id, :subject, :subject_abbrev)
  end

  def create
    if params[:teachings_by_subject]
      @start_date = params[:teachings_by_subject][:start_date]
      @end_date = params[:teachings_by_subject][:end_date]
      @status = params[:teachings_by_subject][:status]
      @department = params[:teachings_by_subject][:subject]
      respond_to do |format|
        format.html {
          redirect_to staff_manager_reports_teachings_by_subject_path(start: @start_date, end: @end_date, status: @status, subject: @subject)
        }
      end
    end
  end
end
