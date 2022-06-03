class Staff::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_access

  private

  def check_access

    logger.debug "STAFF BASE = ACCESS: #{@access}"
    if @access == 'staff' || @access == 'manager' || @access == 'admin'
      # do nothing
      logger.debug "I am #{@access}"
    elsif @access == 'staff_under_review'
      logger.debug "I am #{@access}"
      redirect_to user_dashboard_path, alert: I18n.t('access_denied_staff_access_is_pending')

    else
      logger.debug "Forbidden"
       render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    end



    # if current_user.staff_profile &&
    #   current_user.staff_profile.is_approved == true &&
    #   (current_user.staff_profile.role.manager? || current_user.staff_profile.role.administrator?)
    #     @auth_check = 'I have a profile, I am an admin and I am approved!'
    #     logger.info 'I have a profile, I am an admin and I am approved!'
    #     @can_access = true
    #
    # elsif current_user.staff_profile &&
    #   current_user.staff_profile.is_approved == false
    #     logger.info "I have a profile, but I am not approved, didn't bother with admin check"
    #     @auth_check = "I have a profile, but I am not approved, didn't bother with admin check"
    #
    # elsif current_user.staff_profile &&
    #   current_user.staff_profile.is_approved == true &&
    #   (!current_user.staff_profile.role.manager? || !current_user.staff_profile.role.administrator?)
    #     logger.info 'I have a profile, I am approved but I am not an admin'
    #     @auth_check = 'I have a profile, I am approved but I am not an admin'
    # elsif !current_user.staff_profile
    #   logger.info 'I do not have a staff profile'
    #   @auth_check = 'I do not have a staff profile'
    #   # render :status => 403
    #   # raise ActionDispatch::PublicExceptions.new(Rails.public_path)
    #   # raise ActionController::RoutingError.new("#{Rails.root}"
    #   # raise ActionController::RoutingError.new('Forbidden')
    #   render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    #   # redirect_to root_url, notice: "You are not authorized to use this part of the website"
    # else
    #   @auth_check = 'Failed, I am in else'
    #   render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    # end
  end

end
