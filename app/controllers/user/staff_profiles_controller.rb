class User::StaffProfilesController < User::BaseController
  before_action :set_staff_profile, only: %i[show edit update destroy]

  # GET /staff_profiles or /staff_profiles.json
  def index
    @staff_profiles = StaffProfile.all
  end

  # GET /staff_profiles/1 or /staff_profiles/1.json
  def show; end

  # GET /staff_profiles/new
  def new
    @staff_profile = StaffProfile.new
  end

  # GET /staff_profiles/1/edit
  def edit; end

  # POST /staff_profiles or /staff_profiles.json
  def create
    @staff_profile = StaffProfile.new(staff_profile_params)

    respond_to do |format|
      if @staff_profile.save
        format.html { redirect_to @staff_profile, notice: 'Staff profile was successfully created.' }
        format.json { render :show, status: :created, location: @staff_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_profiles/1 or /staff_profiles/1.json
  def update
    respond_to do |format|
      if @staff_profile.update(staff_profile_params)
        format.html { redirect_to @staff_profile, notice: 'Staff profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @staff_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_profiles/1 or /staff_profiles/1.json
  def destroy
    @staff_profile.destroy
    respond_to do |format|
      format.html { redirect_to staff_profiles_url, notice: 'Staff profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_staff_profile
    @staff_profile = StaffProfile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def staff_profile_params
    params.require(:staff_profile).permit(:specializtion_job_title, :profile_bio, :role, :department_id, :user_id,
                                          :is_approved)
  end
end
