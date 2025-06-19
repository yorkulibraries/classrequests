class Staff::TeachingRequestsController < Staff::BaseController
  before_action :set_teaching_request, only: [:show, :edit, :update, :destroy]
  before_action :set_active_instructors, only: [:new, :show, :edit, :create, :update]
  # invisible_captcha only: [:create, :update], on_spam: :your_spam_callback_method

  def show
  end

  def new
    @teaching_request = current_user.teaching_requests.new(first_name: current_user.first_name, last_name: current_user.last_name, username: current_user.username, email: current_user.email, submitted_by: current_user.full_name, patron_type: 0, status: :assigned)

    show_acad_years = ["#{2.year.ago.year}-#{1.year.ago.year}","#{1.year.ago.year}-#{Date.today.year}","#{Date.today.year}-#{1.year.from_now.year}"]
    @academic_terms = InstituteCourse.select('distinct(academic_term)').to_a
    @academic_years = {} #InstituteCourse.select('distinct(academic_year)').where(academic_year: show_acad_years).to_a


    @course_faculties = {}
    @faculty_departments = {}
    @disable_lead = false

    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1]}).where(is_active: true).order(:first_name)
  end

  def edit

    @academic_terms = InstituteCourse.select(:academic_term).distinct
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')
    @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @teaching_request.faculty_abbrev)
    @disable_lead = true
    ## For Active instructors assigned
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1]}).where(is_active: true).order(:first_name)
  end

  def create

    @teaching_request = current_user.teaching_requests.new(teaching_request_params)
    @academic_terms = InstituteCourse.select(:academic_term).distinct
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')
    @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where.not(staff_profiles: {role: [0,1]}).where(is_active: true).order(:first_name)

    if @teaching_request.faculty_abbrev != nil
      @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @teaching_request.faculty_abbrev)
    else
      @faculty_departments = {}
    end

    respond_to do |format|
      if @teaching_request.save

        ## SEND USER EMAIL
        # RequestorMailer.request_submission_confirmation(@request).deliver_now

        ## SEND ADMIN EMAIL
        # AdminMailer.request_notification(@request).deliver_now

        format.html { redirect_to staff_dashboard_path(), notice: t(:request_successfully_submitted) }
      else
        format.html { render :new }
        # ## SEND ADMIN EMAIL
        # message = "Could not process request with ID: #{params[:id]}"
        # AdminMailer.error_notification(message).deliver_now

        # format.json { render json: @teaching_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @academic_terms = InstituteCourse.select(:academic_term).distinct
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')

    if @teaching_request.faculty_abbrev != nil
      @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @teaching_request.faculty_abbrev)
    else
      @faculty_departments = {}
    end

    respond_to do |format|
      if @teaching_request.update(teaching_request_params)
        # format.html { redirect_to @teaching_request, notice: 'Request was successfully updated.' }
        format.html { redirect_to staff_teaching_request_path(@teaching_request), sort: @teaching_request.status.text, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @teaching_request }
      else
        format.html { render :edit }
        format.json { render json: @teaching_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user/requests/1
  # DELETE /user/requests/1.json
  def destroy
    @teaching_request.status = TeachingRequest.status.deleted
    respond_to do |format|
      if @teaching_request.update(teaching_request_params)
        format.html { redirect_to staff_dashboard_path, notice: 'TeachingRequest was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to staff_dashboard_path, notice: 'Teaching Request could not be deleted.' }
        format.json { render json: @teaching_request.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching_request
      @teaching_request = TeachingRequest.find(params[:id])
    end

    def set_active_instructors
      @active_instructors = User.includes(:staff_profile).references(:staff_profiles).where(staff_profiles: {role: 2}).where(is_active: true).order(:first_name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teaching_request_params
      params.require(:teaching_request).permit(:username, :patron_type, :first_name, :last_name, :email, :phone, :academic_term, :academic_year, :faculty, :faculty_abbrev, :subject, :subject_abbrev, :course_title, :course_number, :submitted_by, :submitted_on_behalf, :section_name_or_about, :number_of_students, :preferred_date, :preferred_time, :alternate_date, :alternate_time, :duration, :location_preference, :room, :lead_instructor_id, :second_instructor_id, :third_instructor_id, :request_note, :instructor_notes, :status, :user_id, :campus_location_id, type_of_instruction_ids: [])
    end

    def your_spam_callback_method
      redirect_to root_path
    end
end
