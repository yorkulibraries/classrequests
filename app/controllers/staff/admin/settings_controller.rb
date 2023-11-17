class Staff::Admin::SettingsController < Staff::Admin::BaseController

  def create
    @errors = ActiveModel::Errors.new(self)
    setting_params.keys.each do |key|
      next if setting_params[key].nil?

      setting = Setting.new(var: key)
      setting.value = setting_params[key].strip
      unless setting.valid?
        @errors.merge!(setting.errors)
      end
    end

    if @errors.any?
      render :new
    end

    setting_params.keys.each do |key|
      Setting.send("#{key}=", setting_params[key].strip) unless setting_params[key].nil?
    end

    redirect_to staff_admin_settings_path, notice: 'Setting was successfully updated.'
  end

  private
    def setting_params
      params.require(:setting).permit(:release_version, :app_name, :web_host, :global_notice, :welcome_message, :delivery_method, :mail_host, :mail_port, :system_from_name, :system_from_email, :new_request_notification, :cancel_request_notification, :system_admin_emails, :manager_emails, :enable_devise_database_auth, :enable_staff_access_request, :enable_devise_PPY, :enable_annoucements, :enable_notifications, :logo_url, :login_banner_url, :homepage_banner_url,:director_name, :director_position, :director_email, :archives_contact, :law_contact, :all_contact, :questions_inquiries_contact, :other_campus_contact, :library_homepage_url, :university_homepage_url, :mail_logo_url)
    end
end
