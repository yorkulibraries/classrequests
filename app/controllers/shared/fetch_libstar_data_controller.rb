class Shared::FetchLibstarDataController < ApplicationController

  def index
    Rails.logger.debug "\n************I AM IN INDEX ***************\n"
    Rails.logger.debug "Faculty: " + params[:faculty_name] if params[:faculty_name]
    Rails.logger.debug "Subject: " + params[:subject_name] if params[:subject_name]
    Rails.logger.debug "Academic: " + params[:academic_year] if params[:academic_year]

    ## FETCH FACULITIES DATA
    if(!params[:faculty_name] || params[:faculty_name] == '') &&
      (!params[:subject_name] || params[:subject_name] == '') &&
      (params[:academic_year] && params[:academic_year] != '')

      @fetched_data = InstituteCourse.select(:faculty, :faculty_abbrev).where('academic_year= ?', params[:academic_year] ).group(:faculty).order(:faculty_abbrev)

    ## FETCH SUBJECTS DATA
    elsif(params[:faculty_name] && params[:faculty_name] != '') &&
      (!params[:subject_name] || params[:subject_name] == '') &&
      (params[:academic_year] && params[:academic_year] != '')


      @fetched_data = InstituteCourse.select(:subject, :subject_abbrev).where('faculty_abbrev like ? and academic_year= ?', params[:faculty_name], params[:academic_year] ).group(:subject).order(:subject_abbrev)

    ## FETCH COURSE DATA
    elsif(params[:faculty_name] && params[:faculty_name] != '') &&
         (params[:subject_name] && params[:subject_name] != '') &&
         (params[:academic_year] && params[:academic_year] != '')

      @fetched_data = InstituteCourse.select(:id, :title, :number, :academic_term, :credits, :academic_year).where(faculty_abbrev:params[:faculty_name]).where('subject_abbrev = ? and academic_year= ?', params[:subject_name],params[:academic_year]).order(:number,:title)

    ## FETCH CAMPUS
    # elsif (params[:campus_id] && params[:campus_id] != '')
    #   @fetched_data = Location.where(campus_id: params[:campus_id])
    # ## SHOW NO DATA
    else
      @fetched_data = Array('No Data')
    end

    respond_to do |format|
      format.html { @fetched_data }
      format.json { render json: @fetched_data }
    end

  end

end
