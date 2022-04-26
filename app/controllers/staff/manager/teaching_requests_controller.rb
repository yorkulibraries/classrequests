class Staff::Manager::TeachingRequestsController < Staff::Manager::BaseController
  before_action :set_teaching_request, only: [:show, :edit, :update, :destroy]
  # invisible_captcha only: [:create, :update], on_spam: :your_spam_callback_method

  def index
    if params[:sort] && params[:sort] == TeachingRequest.status.new_request.text
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.new_request.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == TeachingRequest.status.in_process.text
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.in_process.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == TeachingRequest.status.assigned.text
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.assigned.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == TeachingRequest.status.unfulfilled.text
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.unfulfilled.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == TeachingRequest.status.deleted.text
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.deleted.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == TeachingRequest.status.not_submitted.text
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.not_submitted.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == t(:all)
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.new_request.value).or(TeachingRequest.where(status: TeachingRequest.status.in_process.value )).or(TeachingRequest.where(status: TeachingRequest.status.assigned.value)).order(created_at: :desc).page params[:page]
    else
      @teaching_requests = TeachingRequest.where(status: TeachingRequest.status.new_request.value).or(TeachingRequest.where(status: TeachingRequest.status.in_process.value)).order(created_at: :desc).page params[:page]
    end

    # @teaching_requests = TeachingRequest.all
    # @course_faculties = InstituteCourse.select('distinct(faculty)')
    @teaching_requests_valid_count = TeachingRequest.where(status: TeachingRequest.status.new_request.value).or(TeachingRequest.where(status: TeachingRequest.status.in_process.value)).or(TeachingRequest.where(status: TeachingRequest.status.assigned.value)).count

    respond_to do |format|
      format.html {  }
    end
  end

  def show
  end

  def new
    # @teaching_request = TeachingRequest.new
    @teaching_request = current_user.teaching_requests.new(first_name: current_user.first_name, last_name: current_user.last_name, username: current_user.username, email: current_user.email, submitted_by: current_user.full_name, patron_type: 0)

    # e.g. ['2020-2021', '2021-2022']
    # show_acad_years = ['#{two_years_ago}-#{previous_year}', '#{previous_year}-#{current_year}']
    # @academic_years = InstituteCourse.select('distinct(academic_year)').where(academic_year: show_acad_years).to_a
    @academic_years = InstituteCourse.select(:academic_year).distinct

    @course_faculties = {}
    @faculty_departments = {}
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1]}).where(is_active: true).order(:first_name)
  end

  def edit
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')
    @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @teaching_request.faculty_abbrev)
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1] }).where(is_active: true).order(:first_name)
  end

  def create
    @teaching_request = current_user.teaching_requests.new(teaching_request_params)
    @teaching_request.status = TeachingRequest.status.new_request
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')
    # @teaching_request.status = TeachingRequest::NEW_REQUEST

    logger.debug '************** REQUEST PARAMS **********'
    logger.debug 'PARAM: ' + teaching_request_params['faculty_abbrev']
    logger.debug 'TeachingRequest FacABBRV: ' + @teaching_request.faculty_abbrev

    if @teaching_request.faculty_abbrev != nil
      @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @teaching_request.faculty_abbrev)
    else
      @faculty_departments = {}
    end

    respond_to do |format|
      if @teaching_request.save

        ## NO EMAILS ARE SENT WHEN MANAGER/STAFF CREATING TEACHING REQUESTS
        ## SEND USER EMAIL
        # RequestorMailer.request_submission_confirmation(@request).deliver_now

        ## SEND ADMIN EMAIL
        # AdminMailer.request_notification(@request).deliver_now

        format.html { redirect_to staff_dashboard_path(), notice: t(:request_successfully_submitted) }
      else
        format.html { render :new }
        # ## SEND ADMIN EMAIL
        # message = 'Could not process request with ID: #{params[:id]}'
        # AdminMailer.error_notification(message).deliver_now
      end
    end
  end

  def update
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1] }).where(is_active: true).order(:first_name)

    if @teaching_request.faculty_abbrev != nil
      @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @teaching_request.faculty_abbrev)
    else
      @faculty_departments = {}
    end

    respond_to do |format|
      if @teaching_request.update(teaching_request_params)
        # format.html { redirect_to @teaching_request, notice: 'Request was successfully updated.' }
        format.html { redirect_to staff_manager_teaching_requests_path, sort: @teaching_request.status.text, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @teaching_request }
      else
        format.html { render :edit }
        format.json { render json: @teaching_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @teaching_request.destroy
    respond_to do |format|
      if @teaching_request.destroy
        format.html { redirect_to staff_manager_dashboard_path, notice: 'TeachingRequest was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to staff_manager_dashboard_path, notice: 'Teaching Request could not be deleted.' }
        format.json { render json: @teaching_request.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching_request
      @teaching_request = TeachingRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teaching_request_params
      params.require(:teaching_request).permit(:username, :patron_type, :first_name, :last_name, :email, :phone, :academic_year, :faculty, :faculty_abbrev, :subject, :subject_abbrev, :course_title, :course_number, :submitted_by, :submitted_on_behalf, :section_name_or_about, :number_of_students, :preferred_date, :preferred_time, :alternate_date, :alternate_time, :duration, :location_preference, :room, :lead_instructor_id, :second_instructor_id, :third_instructor_id, :request_note, :instructor_notes, :status, :user_id)

    end

    # def your_spam_callback_method
    #   redirect_to root_path
    # end
end
