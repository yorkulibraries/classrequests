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

    end

end
