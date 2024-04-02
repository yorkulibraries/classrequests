class Staff::Manager::Reports::TeachingsBySubjectsController < ApplicationController
  layout 'staff/manager/base'

  def index
    logger.debug '*************** REPORTS ************** '
    logger.debug "Start: #{params[:start]}"
    logger.debug "End: #{params[:end]}"
    logger.debug "Status: #{params[:status]}"
    logger.debug "Subject: #{params[:subject]}"

    case
    #Case 1: Missing Start/End Dates or all blank
    when (params[:start].blank? && params[:end].blank? && params[:status].blank? && params[:department].blank?) || (params[:start].blank? || params[:end].blank?)
      logger.debug "Case 1: Missing Start/End Dates or all blank"
      flash.now[:error] = "Start date and end date are required fields."
      render action: "index"
      return

    #Case 2: Only Dates
    when params[:start].present? && params[:end].present? && params[:status].blank? && params[:subject].blank?
      logger.debug "Case 2: Only Dates"
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @subject = params[:subject]

      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: [:assigned, :done]) 
      
    #Case 3: Subject yes, Status no"
    when params[:start].present? && params[:end].present? && params[:status].blank? && params[:subject].present?
      logger.debug "Case 3: Subject yes, Status no"
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @subject= params[:subject]
      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(subject: @subject).where.not(status: TeachingRequest.status.deleted)
    
    # Case 4: Subject yes, Status yes
    when params[:start].present? && params[:end].present? && params[:status].present? && params[:subject].present?
      logger.debug "Case 4: Subject yes, Status yes"
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @subject= params[:subject]
      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(subject: @subject).where(status: @status)
  
    # Case 5: Subject no, Status yes
    when params[:start].present? && params[:end].present? && params[:status].present? && params[:subject].blank?
      logger.debug "Case 5: Subject no, Status yes"
      @start_date = params[:start]
      @end_date = params[:end]
      @status = params[:status]
      @subject= params[:subject]
      @results = TeachingRequest.where(preferred_date: @start_date..@end_date).where(status: @status)
    else
      # Case 6
      logger.debug "Case 6: No Results"
      flash.now[:warning] = "No Results"
      @results = {}
    end

    # end
    respond_to do |format|
      format.html
      # format.csv { send_data @results.to_csv }
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"#{@start_date}_teachings_by_date_and_subject.xlsx\""}
    end

  end

  def new
    @status_list_enum = TeachingRequest.status.options(except: [:not_submitted, :deleted])
    @subjects_list = InstituteCourse.distinct.pluck(:subject, :subject_abbrev)
    @counts_by_faculty = TeachingRequest.select('faculty, faculty_abbrev, COUNT(*) as teachings').group('faculty, faculty_abbrev').order('teachings DESC')
    @counts_by_subject = TeachingRequest.select('subject, subject_abbrev, COUNT(*) as teachings').where.not(status: TeachingRequest.status.deleted).group('subject, subject_abbrev').order('teachings DESC')
  end

  def create
    if params[:teachings_by_subjects]
      @start_date = params[:teachings_by_subjects][:start_date]
      @end_date = params[:teachings_by_subjects][:end_date]
      @status = params[:teachings_by_subjects][:status]
      @subject = params[:teachings_by_subjects][:subject]
      respond_to do |format|
        format.html {
          redirect_to staff_manager_reports_teachings_by_subjects_path(start: @start_date, end: @end_date, status: @status, subject: @subject)
        }
      end
    end
  end
end
