class Switchboard::OperatorsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user && !current_user.staff_profile
      redirect_to user_dashboard_path

    elsif current_user != nil && current_user.staff_profile && current_user.staff_profile.is_approved == false
      redirect_to user_dashboard_path, alert: I18n.t('redirect_to_user_dashboard_staff_access_is_pending')

    elsif current_user && current_user.staff_profile && current_user.staff_profile.is_approved == true
      redirect_to staff_dashboard_path

      # if current_user.staff_profile.student_staff? || current_user.staff_profile.staff_instructor?
      #   redirect_to staff_dashboard_path, notice: 'Welcome Staff to #{current_user.first_name} LibSTAR Dashboard'
      # elsif current_user.staff_profile.manager?
      #   redirect_to staff_manager_dashboard_path, notice: 'Welcome Manager to #{current_user.first_name} LibSTAR Dashboard'
      # elsif current_user.staff_profile.administrator?
      #   redirect_to staff_admin_dashboard_path, notice: 'Welcome Admin to #{current_user.first_name} LibSTAR Dashboard'
      # else
      #   redirect_to user_dashboard_path, warning: 'Your Staff Access Request is still Pending'
      # end
    else
      redirect_to root_url
      # redirect_to user_session_path, notice: 'Sign in'
    end

  end
end
