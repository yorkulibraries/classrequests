class Shared::FetchLibstarDataController < ApplicationController

  def index
    Rails.logger.debug "\n************I AM IN INDEX ***************\n"
    Rails.logger.debug "Academic Term: #{params[:academic_term]}" if params[:academic_term]
    Rails.logger.debug "Academic Year: #{params[:academic_year]}" if params[:academic_year]
    Rails.logger.debug "Faculty: #{params[:faculty_name]}" if params[:faculty_name]
    Rails.logger.debug "Subject: #{params[:subject_name]}" if params[:subject_name]

    # FETCH TERMS DATA
    if !params[:academic_term]
      @fetched_data = InstituteCourse.select(:academic_term).distinct.order(:academic_term)

    # FETCH YEARS FOR TERM
    elsif params[:academic_term].present? && !params[:academic_year]
      @fetched_data = InstituteCourse
                        .select(:academic_year)
                        .where(academic_term: params[:academic_term])
                        .distinct
                        .order(:academic_year)

    # FETCH FACULTIES
    elsif params[:academic_term].present? && params[:academic_year].present? &&
          !params[:faculty_name] && !params[:subject_name]

      @fetched_data = InstituteCourse
                        .select(:faculty, :faculty_abbrev)
                        .where(academic_term: params[:academic_term], academic_year: params[:academic_year])
                        .group(:faculty, :faculty_abbrev)
                        .order(:faculty_abbrev)

    # FETCH SUBJECTS
    elsif params[:academic_term].present? && params[:academic_year].present? &&
          params[:faculty_name].present? && !params[:subject_name]

      @fetched_data = InstituteCourse
                        .select(:subject, :subject_abbrev)
                        .where(academic_term: params[:academic_term], academic_year: params[:academic_year], faculty_abbrev: params[:faculty_name])
                        .group(:subject, :subject_abbrev)
                        .order(:subject_abbrev)

    # FETCH COURSE DATA
    elsif params[:academic_term].present? && params[:academic_year].present? &&
          params[:faculty_name].present? && params[:subject_name].present?

      @fetched_data = InstituteCourse
                        .select(:id, :title, :number, :academic_term, :credits, :academic_year)
                        .where(academic_term: params[:academic_term],
                              academic_year: params[:academic_year],
                              faculty_abbrev: params[:faculty_name],
                              subject_abbrev: params[:subject_name])
                        .order(:number, :title)

    # FETCH COURSE TITLE
    elsif params[:course_title].present?
      @fetched_data = InstituteCourse.select(:title)
                                    .where("title LIKE ?", "%#{params[:course_title]}%")
                                    .limit(10)
                                    .pluck(:title)

    elsif(!params[:course_title] || params[:course_title] != '') 
    # puts "I AM IN COURSE TITLE"
      @fetched_data = InstituteCourse.select(:title).where("title LIKE ?", "%#{params[:course_title]}%").limit(10).pluck(:title)
    else
      @fetched_data = Array('No Data')
    end


    respond_to do |format|
      format.html { @fetched_data }
      format.json { render json: @fetched_data }
    end

  end

end
