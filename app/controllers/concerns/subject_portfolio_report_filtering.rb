module SubjectPortfolioReportFiltering
  extend ActiveSupport::Concern

  private

  def apply_subject_portfolio_filter
    @subject_portfolio_filter = params[:subject_portfolio]
    @subject_portfolio_filter_label = subject_portfolio_filter_label
    return unless @results.respond_to?(:for_subject_portfolio_filter)

    @results = @results
               .for_subject_portfolio_filter(@subject_portfolio_filter)
               .includes(:subject_portfolio)
  end

  def subject_portfolio_filter_label
    case @subject_portfolio_filter.to_s
    when ''
      I18n.t('subject_portfolios.classification.reports.all')
    when TeachingRequest::WITHOUT_SUBJECT_PORTFOLIO_FILTER
      I18n.t('subject_portfolios.classification.legacy_label')
    else
      SubjectPortfolio.find_by(id: @subject_portfolio_filter)&.name ||
        I18n.t('subject_portfolios.classification.reports.all')
    end
  end
end
