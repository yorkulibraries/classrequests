module DeviseWhitelist
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username first_name last_name contact_phone user_uid alternate_email user_source user_group iam_identification note announcements_last_read_at is_active is_verified])

    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[username first_name last_name contact_phone user_uid alternate_email user_source user_group iam_identification note announcements_last_read_at is_active is_verified])
  end
end
