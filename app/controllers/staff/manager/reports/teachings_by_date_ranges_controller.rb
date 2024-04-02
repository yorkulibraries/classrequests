class Staff::Manager::Reports::TeachingsByDateRangesController < ApplicationController
  layout 'staff/manager/base'

  def index
    logger.debug '*************** REPORTS ************** '
    logger.debug "Start: #{params[:start]}"
    logger.debug "End: #{params[:end]}"
    logger.debug "Status: #{params[:status]}"

    if (params[:start] && params[:end] && params[:status]) && (params[:start] == '' || params[:end] == '') && (params[:status] = '')

      logger.debug 'Params present but no values -- first if'
      @results = TeachingRequest.where.not(status: TeachingRequest.status.deleted) #('status != ?', TeachingRequest.status.deleted)


    elsif (params[:start] && params[:end]) && (params[:start] != '' && params[:end] != '') && (!params[:status] || params[:status] == '')

      logger.debug 'No Status Provided -- I am in elsif #1'
      @start_date = params[:start]
      @end_date = params[:end]

      # @results = TeachingRequest.where('preferred_date BETWEEN ? AND ? AND status != ?', @start_date, @end_date, TeachingRequest.status.deleted)
      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where.not(status: TeachingRequest.status.deleted)

      # .where(Section.where.not(status: Section::UNFULFILLED)
    elsif (params[:start] && params[:end] && params[:status]) && (params[:start] != '' && params[:end] != '' && params[:status] != '')
      logger.debug 'All three provided -- I am in elsif #2'

      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]

      # status_value = TeachingRequest.status.find_value(@status).value
      # @results = TeachingRequest.where('preferred_date BETWEEN ? AND ? AND status = ?', @start_date, @end_date, @status)
      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: @status)

    else
      logger.debug 'No Results Found or Invalid Dates/Status -- in else'
      @results = {}

    end
    respond_to do |format|
      format.html
      # format.csv { send_data @results.to_csv }
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"#{@start_date}_teachings_by_date.xlsx\""}
    end

  end

  def new
    @status_list_enum = TeachingRequest.status.options(except: [:not_submitted])
  end

  def create
    if params[:teachings_by_date_ranges]
      @start_date = params[:teachings_by_date_ranges][:start_date]
      @end_date = params[:teachings_by_date_ranges][:end_date]
      @status = params[:teachings_by_date_ranges][:status]
      respond_to do |format|
        format.html {
          redirect_to staff_manager_reports_teachings_by_date_ranges_path(start: @start_date, end: @end_date, status: @status)
        }
      end
    end
  end
end
