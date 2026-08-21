require 'test_helper'

class Staff::Manager::Reports::TeachingsByDateRangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @subject_portfolio = create(:subject_portfolio, name: 'Humanities')
    @tagged_request = create(
      :default_teaching_request,
      status: :done,
      preferred_date: Date.current,
      subject_portfolio: @subject_portfolio
    )
    @legacy_request = create(
      :default_teaching_request,
      status: :done,
      preferred_date: Date.current,
      subject_portfolio: nil
    )
    sign_in @manager
  end

  test 'report includes tagged and legacy requests by default' do
    get report_path

    assert_response :success
    assert_select request_link_selector(@tagged_request)
    assert_select request_link_selector(@legacy_request)
    assert_includes response.body, @subject_portfolio.name
    assert_includes response.body, I18n.t('subject_portfolios.classification.legacy_label')
  end

  test 'report form offers all, legacy, and named portfolio filters' do
    get staff_manager_reports_overview_path

    assert_response :success
    assert_includes response.body, I18n.t('subject_portfolios.classification.reports.all')
    assert_includes response.body, I18n.t('subject_portfolios.classification.legacy_label')
    assert_includes response.body, @subject_portfolio.name
  end

  test 'report can show only requests without a portfolio' do
    get report_path(subject_portfolio: TeachingRequest::WITHOUT_SUBJECT_PORTFOLIO_FILTER)

    assert_response :success
    assert_select request_link_selector(@legacy_request)
    assert_select request_link_selector(@tagged_request), count: 0
  end

  test 'report can filter by a subject portfolio' do
    get report_path(subject_portfolio: @subject_portfolio.id)

    assert_response :success
    assert_select request_link_selector(@tagged_request)
    assert_select request_link_selector(@legacy_request), count: 0
  end

  test 'Excel export preserves the portfolio filter' do
    get report_path(subject_portfolio: @subject_portfolio.id, format: :xlsx)

    assert_response :success
    assert_equal Mime[:xlsx].to_s, response.media_type
    assert_operator response.body.bytesize, :>, 100
  end

  test 'staff instructor cannot access manager reports' do
    sign_out @manager
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    get report_path

    assert_response :forbidden
  end

  test 'unauthenticated user is redirected to sign in' do
    sign_out @manager

    get report_path

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'unauthenticated user cannot access the manager subject report' do
    sign_out @manager

    get staff_manager_reports_teachings_by_subjects_path

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  private

  def report_path(overrides = {})
    staff_manager_reports_teachings_by_date_ranges_path(
      {
        start: Date.current.to_s,
        end: Date.current.to_s,
        status: TeachingRequest.status.done.value
      }.merge(overrides)
    )
  end

  def request_link_selector(teaching_request)
    "a[href='#{staff_manager_teaching_request_path(teaching_request)}']"
  end
end
