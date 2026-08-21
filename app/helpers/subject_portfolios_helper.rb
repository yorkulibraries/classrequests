module SubjectPortfoliosHelper
  LEAD_ASSIGNMENT_BADGE_CLASSES = {
    awaiting_response: 'bg-warning text-dark',
    accepted: 'bg-success',
    declined: 'bg-danger',
    confirmed_without_response: 'bg-success',
    no_response_recorded: 'bg-danger'
  }.freeze

  def subject_portfolio_label_for(teaching_request)
    teaching_request.subject_portfolio&.name ||
      t('subject_portfolios.classification.legacy_label')
  end

  def lead_assignment_state_badge_for(teaching_request)
    state = teaching_request.lead_assignment_state
    return if state.blank?

    content_tag(
      :span,
      t("subject_portfolios.lead_assignment_states.#{state}"),
      class: "badge fs-6 #{LEAD_ASSIGNMENT_BADGE_CLASSES.fetch(state)} ms-1",
      data: { lead_assignment_state: state }
    )
  end

  def subject_portfolio_filter_options
    options = [
      [t('subject_portfolios.classification.reports.all'), ''],
      [
        t('subject_portfolios.classification.legacy_label'),
        TeachingRequest::WITHOUT_SUBJECT_PORTFOLIO_FILTER
      ]
    ]

    options + SubjectPortfolio.order(:name).pluck(:name, :id)
  end
end
