class ApplicationController < ActionController::Base
  before_action :set_timezone
  before_action :set_locale
  before_action :user_type_check

  def set_timezone
    Time.zone = 'America/Toronto'
  end

  include DeviseWhitelist

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  # override the devise method for where to go after signing out because theirs
  # always goes to the root path. Because devise uses a session variable and
  # the session is destroyed on log out, we need to use request.referrer
  # root_path is there as a backup
  def after_sign_in_path_for(resource)
    flash.clear
    flash[:notice] = 'Signed in successfully'
    operators_index_url
    # root_url
  end
  def after_sign_out_path_for(_resource)
    request.referrer || operators_index_url
  end

  def user_type_check
    if current_user != nil && current_user.staff_profile &&
      current_user.staff_profile.is_approved == true &&
      current_user.staff_profile.role.administrator?
        @auth_check = 'I have a profile, I am an admin and I am approved!'
        logger.debug 'I have a profile, I am an admin and I am approved!'
        @access = 'admin'

    elsif current_user != nil && current_user.staff_profile &&
      current_user.staff_profile.is_approved == true &&
      current_user.staff_profile.role.manager?
        @auth_check = 'I have a profile, I am an admin and I am approved!'
        logger.debug 'I have a profile, I am an admin and I am approved!'
        @access = 'manager'

    elsif current_user != nil && current_user.staff_profile && current_user.staff_profile.is_approved == false
        logger.debug "I have a profile, but I am not approved, didn't bother with admin check"
        @access = 'user'

    elsif current_user != nil && current_user.staff_profile &&
      current_user.staff_profile.is_approved == true &&
      (current_user.staff_profile.role.staff_instructor?)
        logger.debug 'I have a profile, I am approved but I am not an admin'
        @access = 'staff'

    elsif current_user && !current_user.staff_profile
      logger.debug 'I do not have a staff profile'
      @access = 'user'
    else
      @access = 'public'

    end
  end
end
