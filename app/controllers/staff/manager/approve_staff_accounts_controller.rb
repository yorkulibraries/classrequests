class Staff::Manager::ApproveStaffAccountsController < Staff::Manager::BaseController
  # before_action :set_staff_profile, only: %i[update destroy]

  def update

    @staff_profile = StaffProfile.find(params[:staff_profile][:id])

    respond_to do |format|
      # if @staff_profile.update(is_approved: params[:is_approved])
      if @staff_profile.update(staff_profile_params)
        format.html { redirect_to staff_manager_dashboard_path, notice: 'User was successfully updated/approved.' }
      else
        format.html { redirect_to staff_manager_dashboard_path, error: 'User was not approved.' }
        format.json { render json: @staff_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @staff_profile.destroy
    respond_to do |format|
      format.html { redirect_to staff_manager_dashboard_path, notice: 'Staff profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_staff_profile
    # @staff_profile = StaffProfile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def staff_profile_params
    # params.require(:staff_profile).permit(:specializtion_job_title, :profile_bio, :role, :department_id, :user_id, :is_approved)
    params.require(:staff_profile).permit(:id, :is_approved, :role)
  end

end
