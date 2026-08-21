class Staff::Manager::PortfolioClassificationsController < Staff::Manager::BaseController
  before_action :set_teaching_request
  before_action :set_subject_portfolios

  def edit; end

  def update
    subject_portfolio = selected_subject_portfolio
    return classification_failed if invalid_subject_portfolio?(subject_portfolio)

    if @teaching_request.classify_subject_portfolio(subject_portfolio)
      if @teaching_request.subject_portfolio_notification_required?
        SubjectPortfolioMailer.assignment_notification(@teaching_request).deliver_now
      end
      classification_succeeded
    else
      classification_failed
    end
  end

  private

  def set_teaching_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  def set_subject_portfolios
    @subject_portfolios = SubjectPortfolio.active.order(:name).to_a
    current_portfolio = @teaching_request.subject_portfolio

    if current_portfolio.present? && !@subject_portfolios.include?(current_portfolio)
      @subject_portfolios.unshift(current_portfolio)
    end
  end

  def classification_params
    params.require(:teaching_request).permit(:subject_portfolio_id)
  end

  def selected_subject_portfolio
    portfolio_id = classification_params[:subject_portfolio_id].presence
    return if portfolio_id.blank?

    SubjectPortfolio.find_by(id: portfolio_id)
  end

  def invalid_subject_portfolio?(subject_portfolio)
    portfolio_id = classification_params[:subject_portfolio_id].presence
    return false if portfolio_id.blank?
    return false if subject_portfolio&.active?
    return false if subject_portfolio == @teaching_request.subject_portfolio

    @teaching_request.errors.add(
      :subject_portfolio,
      t('subject_portfolios.assignment.errors.active')
    )
    true
  end

  def classification_succeeded
    flash[:success] = if @teaching_request.subject_portfolio
                        t(
                          'subject_portfolios.classification.notices.updated',
                          portfolio: @teaching_request.subject_portfolio.name
                        )
                      else
                        t('subject_portfolios.classification.notices.removed')
                      end

    respond_to do |format|
      format.html do
        redirect_to staff_manager_teaching_requests_path(
          sort: @teaching_request.status.text
        )
      end
      format.js
    end
  end

  def classification_failed
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.js { render :update, status: :unprocessable_entity }
    end
  end
end
