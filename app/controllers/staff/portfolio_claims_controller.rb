class Staff::PortfolioClaimsController < Staff::BaseController
  before_action :set_teaching_request

  def update
    if @teaching_request.assign_portfolio_lead(current_user)
      RequestorMailer.request_assignment(@teaching_request).deliver_now
      StaffMailer.portfolio_lead_confirmed(@teaching_request, current_user).deliver_now
      redirect_to staff_dashboard_path,
                  notice: t('subject_portfolios.claim.notices.claimed')
    else
      redirect_to staff_dashboard_path,
                  alert: @teaching_request.errors.full_messages.to_sentence
    end
  end

  private

  def set_teaching_request
    @teaching_request = TeachingRequest.find(params[:id])
  end
end
