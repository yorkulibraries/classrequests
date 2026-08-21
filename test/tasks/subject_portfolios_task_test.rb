require 'test_helper'
require 'rake'

class SubjectPortfoliosTaskTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?('subject_portfolios:audit')
    Rake::Task['subject_portfolios:audit'].reenable
  end

  test 'audit reports portfolio and legacy counts without changing records' do
    subject_portfolio = create(:subject_portfolio)
    create(:default_teaching_request, status: :done, subject_portfolio: nil)
    create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    original_attributes = TeachingRequest.order(:id).pluck(
      :id,
      :status,
      :subject_portfolio_id,
      :lead_instructor_id,
      :updated_at
    )

    output, = capture_io { Rake::Task['subject_portfolios:audit'].invoke }

    assert_includes output, 'Total teaching requests: 2'
    assert_includes output, 'Requests with a portfolio: 1'
    assert_includes output, 'Requests without a portfolio: 1'
    assert_includes output, 'Portfolio requests awaiting a lead: 1'
    assert_equal original_attributes, TeachingRequest.order(:id).pluck(
      :id,
      :status,
      :subject_portfolio_id,
      :lead_instructor_id,
      :updated_at
    )
  end
end
