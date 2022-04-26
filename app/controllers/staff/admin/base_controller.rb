class Staff::Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_access


  private

    def check_access
      if @access == 'admin'
        # do nothing
        logger.debug "I am #{@access}"
      else
        logger.debug "Forbidden"
         render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end

    # if current_user.staff_profile &&
    #   current_user.staff_profile.is_approved == true &&
    #   current_user.staff_profile.role.administrator?
    #     logger.debug 'I have a profile, I am an admin and I am approved!'
    #     # print 'I have a profile, I am an admin and I am approved!'
    #     @can_access = true
    #
    # elsif current_user.staff_profile &&
    #   current_user.staff_profile.is_approved == false
    #     # print "I have a profile, but I am not approved, didn't bother with admin check"
    #     logger.debug "I have a profile, but I am not approved, didn't bother with admin check"
    #
    # elsif current_user.staff_profile &&
    #   current_user.staff_profile.is_approved == true &&
    #   !current_user.staff_profile.role.administrator?
    #     # print 'I have a profile, I am approved but I am not an admin'
    #     logger.debug 'I have a profile, I am approved but I am not an admin'
    #     # render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    # elsif !current_user.staff_profile
    #   # print 'I do not have a staff profile'
    #   logger.debug 'I do not have a staff profile'
    #   # render :status => 403
    #   # raise ActionDispatch::PublicExceptions.new(Rails.public_path)
    #   # raise ActionController::RoutingError.new("#{Rails.root}"
    #   # raise ActionController::RoutingError.new('Forbidden')
    #   # render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    #   # redirect_to root_url, notice: "You are not authorized to use this part of the website"
    # else
    #   logger.debug 'Failed, I am in else'
    #   # render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    #
    # end

    end

end
