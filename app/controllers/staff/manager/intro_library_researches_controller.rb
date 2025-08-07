class Staff::Manager::IntroLibraryResearchesController < Staff::Manager::BaseController
  before_action :set_intro_library_research, only: %i[ show edit update destroy ]
  invisible_captcha only: [:create, :update], on_spam: :your_spam_callback_method

  # GET /intro_library_researches or /intro_library_researches.json
  def index
    # @intro_library_researches = IntroLibraryResearch.all
    if params[:sort] && params[:sort] == IntroLibraryResearch.status.new_request.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.new_request.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == IntroLibraryResearch.status.in_process.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.in_process.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == IntroLibraryResearch.status.assigned.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.assigned.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == IntroLibraryResearch.status.done.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.done.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == IntroLibraryResearch.status.unfulfilled.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.unfulfilled.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == IntroLibraryResearch.status.deleted.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.deleted.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == IntroLibraryResearch.status.not_submitted.text
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.not_submitted.value).order(created_at: :desc).page params[:page]
    elsif params[:sort] && params[:sort] == t(:all)
      @intro_library_researches = IntroLibraryResearch.where(status: IntroLibraryResearch.status.new_request.value).or(IntroLibraryResearch.where(status: IntroLibraryResearch.status.in_process.value )).or(IntroLibraryResearch.where(status: IntroLibraryResearch.status.assigned.value)).or(IntroLibraryResearch.where(status: IntroLibraryResearch.status.done.value)).order(created_at: :desc).page params[:page]
    else
      @intro_library_researches = IntroLibraryResearch.all.order(created_at: :desc).page params[:page]
    end

    @intro_library_researches_valid_count = IntroLibraryResearch.where(status: IntroLibraryResearch.status.new_request.value).or(IntroLibraryResearch.where(status: IntroLibraryResearch.status.in_process.value)).or(IntroLibraryResearch.where(status: IntroLibraryResearch.status.assigned.value)).count

  end

  # GET /intro_library_researches/1 or /intro_library_researches/1.json
  def show
  end

  # GET /intro_library_researches/new
  def new
    @intro_library_research = current_user.intro_library_researches.new(first_name: current_user.first_name, last_name: current_user.last_name, username: current_user.username, email: current_user.email, submitted_by: current_user.full_name, patron_type: 0, status: :assigned)
    
    @academic_terms = InstituteCourse.select('distinct(academic_term)').to_a
    @academic_years = {}
    @course_faculties = {}
    @faculty_departments = {}
    @disable_lead = false

  end

  # GET /intro_library_researches/1/edit
  def edit
    @academic_terms = InstituteCourse.select(:academic_term).distinct
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
        # RequestorMailer.request_submission_confirmation(@teaching_request).deliver_now

        ## SEND ADMIN EMAIL
        # AdminMailer.request_notification(@teaching_request).deliver_now

        format.html { redirect_to user_thank_you_intro_library_research_index_path(), notice: t(:request_successfully_submitted) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /intro_library_researches/1 or /intro_library_researches/1.json
  def update
    respond_to do |format|
      if @intro_library_research.update(intro_library_research_params)
        format.html { redirect_to staff_manager_intro_library_research_path(@intro_library_research), notice: "Intro library research was successfully updated." }
        format.json { render :show, status: :ok, location: @intro_library_research }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @intro_library_research.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intro_library_researches/1 or /intro_library_researches/1.json
  def destroy
    @intro_library_research = IntroLibraryResearch.find(params[:id])
    respond_to do |format|
      if @intro_library_research.update(status: IntroLibraryResearch.status.deleted)
        format.html { redirect_to staff_manager_intro_library_researches_path, sort: @intro_library_research.status.text, notice: 'Intro library research was successfully (soft) deleted.' }
      else
        format.html { 
          flash[:error] = "ERROR: Intro Library Research (soft) delete failed! -- #{@intro_library_research.errors.full_messages.to_sentence}" 
          
          redirect_to staff_manager_intro_library_research_path(@intro_library_research) 
          }
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
   