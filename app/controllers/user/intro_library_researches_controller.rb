class User::IntroLibraryResearchesController < User::BaseController
  before_action :set_intro_library_research, only: %i[ show edit update destroy ]
  invisible_captcha only: [:create, :update], on_spam: :your_spam_callback_method

  # GET /intro_library_researches/1 or /intro_library_researches/1.json
  def show
  end

  # GET /intro_library_researches/new
  def new
    @intro_library_research = current_user.intro_library_researches.new(first_name: current_user.first_name, last_name: current_user.last_name, username: current_user.username, email: current_user.email, submitted_by: current_user.full_name, patron_type: 0, status: :assigned)
    
    @academic_terms = InstituteCourse.select('distinct(academic_term)').to_a

    show_acad_years = ["#{1.year.ago.year}","#{Date.today.year}","#{1.year.from_now.year}"]
    @academic_years = InstituteCourse.select('distinct(academic_year)').where(academic_year: show_acad_years).to_a
    @academic_year_options = InstituteCourse.academic_year_options(@academic_year)

    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')

    if @intro_library_research.faculty_abbrev != nil
      @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @intro_library_research.faculty_abbrev)
    else
      @faculty_departments = {}
    end

    @disable_lead = false

  end

  # POST /intro_library_researches or /intro_library_researches.json
  def create
    @intro_library_research = current_user.intro_library_researches.new(intro_library_research_params)
    @intro_library_research.status = IntroLibraryResearch.status.new_request
    @academic_terms = InstituteCourse.select(:academic_term).distinct
    @academic_years = InstituteCourse.select(:academic_year).distinct
    @course_faculties = InstituteCourse.group(:faculty).select('faculty_abbrev, faculty')

    if @intro_library_research.faculty_abbrev != nil
      @faculty_departments = InstituteCourse.group(:subject).select('subject_abbrev, subject').where(faculty_abbrev: @intro_library_research.faculty_abbrev)
    else
      @faculty_departments = {}
    end

    respond_to do |format|
      if @intro_library_research.save
        ## SEND USER EMAIL
        # RequestorMailer.intro_library_research_submission_confirmation(@intro_library_research).deliver_now

        ## SEND ADMIN EMAIL
        AdminMailer.intro_library_research_notification(@intro_library_research).deliver_now

        format.html { redirect_to user_thank_you_intro_library_research_index_path(), notice: t(:request_successfully_submitted) }
      else
        format.html { render :new }
      end
    end
  end


  # DELETE /intro_library_researches/1 or /intro_library_researches/1.json
  def destroy
    @intro_library_research.status = :deleted

    respond_to do |format|
      if @intro_library_research.update(intro_library_research_params)

        format.html { redirect_to user_dashboard_path, notice: "Intro library research was successfully (soft) deleted." }
        format.json { head :no_content }
      else
        format.html { redirect_to user_dashboard_path, notice: 'Intro Library research could not be deleted.' }
        format.json { render json: @intro_library_research.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intro_library_research
      @intro_library_research = IntroLibraryResearch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def intro_library_research_params
      params.require(:intro_library_research).permit(:username, :patron_type, :first_name, :last_name, :email, :phone, :academic_term, :academic_year, :faculty, :faculty_abbrev, :subject, :subject_abbrev, :course_number, :course_title, :section_name_or_about, :status, :submitted_by, :user_id, :campus_location_id)
    end
end
