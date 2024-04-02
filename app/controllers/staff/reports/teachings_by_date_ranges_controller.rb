class Staff::Reports::TeachingsByDateRangesController < Staff::BaseController
  layout 'staff/base'

  def index

    logger.debug '*************** REPORTS ************** '
    logger.debug "Start: #{params[:start]}"
    logger.debug "End: #{params[:end]}"
    logger.debug "Status: #{params[:status]}"

    if (params[:start] && params[:end] && params[:status]) && (params[:start] == '' || params[:end] == '') && (params[:status] = '')

      ### No Start, End and status values
      logger.debug 'Params present but no values -- first if'
      # @results = TeachingRequest.where(lead_instructor: current_user).or(TeachingRequest.where(second_instructor: current_user)).or(TeachingRequest.where(third_instructor: current_user)).where('status != ?', TeachingRequest.status.deleted)

      @results = TeachingRequest.where('lead_instructor_id IN (?) OR second_instructor_id IN (?) OR third_instructor_id IN (?)', @current_user, @current_user, @current_user)


    elsif (params[:start] && params[:end]) && (params[:start] != '' && params[:end] != '') && (!params[:status] || params[:status] == '')

      logger.debug 'No Status Provided -- I am in elsif #1'
      @start_date = params[:start]
      @end_date = params[:end]

      # @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: current_user).or(TeachingRequest.where(second_instructor: current_user)).or(TeachingRequest.where(third_instructor: current_user)).where('status != ?', TeachingRequest.status.deleted)
      # .where(Section.where.not(status: Section::UNFULFILLED)

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where('lead_instructor_id IN (?) OR second_instructor_id IN (?) OR third_instructor_id IN (?)', @current_user, @current_user, @current_user)


    elsif (params[:start] && params[:end] && params[:status]) && (params[:start] != '' && params[:end] != '' && params[:status] != '')

      logger.debug 'All three provided -- I am in elsif #2' 'All three provided -- I am in elsif #2'

      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status].parameterize.underscore.to_sym

      logger.debug 'Teaching Request Status: ' + params[:status]
      # status_value = TeachingRequest.status.find_value(@status).value
      # where('preferred_date BETWEEN ? AND ?', @start_date, @end_date)
      # @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(lead_instructor: current_user, status: @status).or(TeachingRequest.where(second_instructor: current_user, status: @status)).or(TeachingRequest.where(third_instructor: current_user, status: @status)).where('status != ?', TeachingRequest.status.deleted)

      @results = TeachingRequest.where(status: @status).where(preferred_date: @start_date..@end_date).where('lead_instructor_id IN (?) OR second_instructor_id IN (?) OR third_instructor_id IN (?)', @current_user, @current_user, @current_user)

      # logger.debug @results.to_sql
    else
      logger.debug 'I am in else '
      logger.debug 'No Results Found'
      @results = {}

    end
    respond_to do |format|
      format.html
      # format.csv { send_data @results.to_csv }
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"#{@start_date}_teachings_by_date.xlsx\""}
    end
  end

  def new
  end

  def create
    if params[:teachings_by_date_ranges]
      @start_date = params[:teachings_by_date_ranges][:start_date]
      @end_date = params[:teachings_by_date_ranges][:end_date]
      @status = params[:teachings_by_date_ranges][:status]
      respond_to do |format|
        format.html {
          redirect_to staff_reports_teachings_by_date_ranges_path(start: @start_date, end: @end_date, status: @status)
        }
      end
    end
  end
end
