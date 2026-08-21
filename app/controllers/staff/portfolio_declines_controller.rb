class Staff::PortfolioDeclinesController < Staff::BaseController
  before_action :set_teaching_request

  def new
    @subject_portfolio_decline = SubjectPortfolioDecline.new(
      teaching_request: @teaching_request,
      declined_by: current_user
    )

    return if @teaching_request.portfolio_returnable_by?(current_user)

    decline_unavailable
  end

  def create
    @subject_portfolio_decline = SubjectPortfolioDecline.new(
      reason: decline_params[:reason],
      confirmed: decline_params[:confirmed],
      declined_by: current_user
    )

    if @teaching_request.return_portfolio_to_manager(@subject_portfolio_decline)
      StaffMailer.portfolio_assignment_returned(@subject_portfolio_decline).deliver_now
      decline_succeeded
    else
      decline_failed
    end
  end

  private

  def set_teaching_request
    request_id = params[:teaching_request_id] ||
                 params.dig(:subject_portfolio_decline, :teaching_request_id)
    @teaching_request = TeachingRequest.find(request_id)
  end

  def decline_params
    params.require(:subject_portfolio_decline).permit(:reason, :confirmed)
  end

  def decline_succeeded
    flash[:success] = t('subject_portfolios.decline.notices.returned')

    respond_to do |format|
      format.html do
        redirect_to staff_dashboard_path
      end
      format.js
    end
  end

  def decline_failed
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.js { render :create, status: :unprocessable_entity }
    end
  end

  def decline_unavailable
    message = t('subject_portfolios.decline.errors.unavailable')
    @subject_portfolio_decline.errors.add(:base, message)
    flash[:alert] = message

    respond_to do |format|
      format.html { redirect_to staff_dashboard_path, alert: message }
      format.js { render :unavailable, status: :unprocessable_entity }
    end
  end
end
