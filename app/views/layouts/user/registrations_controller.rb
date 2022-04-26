class User::RegistrationsController < Devise::RegistrationsController

  protected

  # To be able to edit and save account details
  def update_resource(resource, params)
    if resource.user_source == 'ppy'
      # params.delete :current_password
      resource.update_without_password(params)
    else
      super
    end
  end
end
