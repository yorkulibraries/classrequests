class Staff::Manager::PortfolioAssignmentsController < Staff::Manager::BaseController
  before_action :set_teaching_request
  before_action :set_subject_portfolios

  def edit
    return if @teaching_request.portfolio_assignable?

    assignment_unavailable
  end

  def update
    subject_portfolio = @subject_portfolios.find_by(id: assignment_params[:subject_portfolio_id])

    if subject_portfolio.nil?
      @teaching_request.errors.add(:subject_portfolio, t("subject_portfolios.assignment.errors.active"))
      return assignment_failed
    end

    assigned = false

    @teaching_request.with_lock do
      if @teaching_request.portfolio_assignable?
        assigned = @teaching_request.update(
          subject_portfolio: subject_portfolio,
          status: :in_process
        )
      else
        @teaching_request.errors.add(:base, t("subject_portfolios.assignment.errors.unavailable"))
      end
    end

    if assigned
      SubjectPortfolioMailer.assignment_notification(@teaching_request).deliver_now
      assignment_succeeded
    else
      assignment_failed
    end
  end

  private

  def set_teaching_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  def set_subject_portfolios
    @subject_portfolios = SubjectPortfolio.active.order(:name)
  end

  def assignment_params
    params.require(:teaching_request).permit(:subject_portfolio_id)
  end

  def assignment_succeeded
    flash[:success] = t(
      "subject_portfolios.assignment.notices.assigned",
      portfolio: @teaching_request.subject_portfolio.name
    )

    respond_to do |format|
      format.html do
        redirect_to staff_manager_teaching_requests_path(
          sort: TeachingRequest.status.in_process.text
        )
      end
      format.js
    end
  end

  def assignment_failed
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.js { render :update, status: :unprocessable_entity }
    end
  end

  def assignment_unavailable
    message = t("subject_portfolios.assignment.errors.unavailable")
    @teaching_request.errors.add(:base, message)

    respond_to do |format|
      format.html do
        redirect_to staff_manager_teaching_requests_path, alert: message
      end
      format.js do
        flash[:alert] = message
        render :unavailable, status: :unprocessable_entity
      end
    end
  end
end
