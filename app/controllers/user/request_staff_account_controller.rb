class User::RequestStaffAccountController < User::BaseController

  def new
    if current_user.staff_profile
      format.html { redirect_to user_dashboard_path, notice: 'You already have an staff profile' }
    else
      @staff_profile = current_user.build_staff_profile
    end
  end

  def create

    @staff_profile = current_user.build_staff_profile(staff_profile_params)

    respond_to do |format|
      if @staff_profile.save
        ## SEND ADMIN EMAIL
        AdminMailer.new_staff_account_notification(current_user).deliver_now

        format.html { redirect_to user_dashboard_path, notice: 'Staff Account has been requested' }
        format.json { render :show, status: :created, location: @staff_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_profile.errors, status: :unprocessable_entity }
      end
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
