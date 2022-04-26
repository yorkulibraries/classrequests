class User::SingleSignOn::PpyLoginsController < ApplicationController
  before_action :authenticate_user!
  def new
    if current_user
      redirect_to operators_index_url, notice: "Greetings #{current_user.first_name}"
    else
      # redirect_to root_url, notice: "Invalid PPY"
    end
  end
end
