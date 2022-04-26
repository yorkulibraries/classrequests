class Staff::Admin::DepartmentsController < Staff::Admin::BaseController
  before_action :set_department, only: %i[show edit update destroy]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all
  end

  # GET /departments/1
  # GET /departments/1.json
  def show; end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit; end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to staff_admin_departments_url, notice: 'Department was successfully created.' }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to staff_admin_departments_url, notice: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to staff_admin_departments_url, notice: 'Department was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_department
    @department = Department.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def department_params
    params.fetch(:department, {}).permit(:name, :branch_division)
    # def teaching_request_params
    #   params.require(:teaching_request).permit(:username, :patron_type, :first_name, :last_name, :email, :phone, :academic_year, :faculty, :faculty_abbrev, :subject, :subject_abbrev, :course_title, :course_number, :submitted_by, :submitted_on_behalf, :section_name_or_about, :number_of_students, :preferred_date, :preferred_time, :alternate_date, :alternate_time, :duration, :location_preference, :lead_instructor_id, :second_instructor_id, :third_instructor_id, :request_note, :instructor_notes, :status, :user_id,)
    # end
  end
end
