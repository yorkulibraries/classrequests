require "application_system_test_case"

class PortfolioAssignmentsTest < ApplicationSystemTestCase
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @subject_portfolio = create(
      :subject_portfolio,
      name: "Humanities",
      notification_email: "humanities@example.com"
    )
    @teaching_request = create(
      :default_teaching_request,
      status: :new_request,
      lead_instructor: nil,
      subject_portfolio: nil
    )

    ActionMailer::Base.deliveries.clear
    sign_in @manager
  end

  teardown do
    Warden.test_reset!
  end

  test "manager assigns a new request to a subject portfolio" do
    visit staff_manager_dashboard_path

    click_on "Assign portfolio"
    assert_selector "#portfolio-assignment-modal", visible: true

    within "#portfolio-assignment-modal" do
      select @subject_portfolio.name, from: "Subject portfolio"
      click_on "Assign portfolio"
    end

    assert_text "Request was assigned to Humanities and the portfolio was notified."
    assert_text "Humanities"
    assert_equal @subject_portfolio, @teaching_request.reload.subject_portfolio
    assert @teaching_request.status.in_process?
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test 'manager adds a portfolio to completed historical work' do
    instructor = create(:user, is_active: true)
    create(:staff_profile, user: instructor, role: :staff_instructor, is_approved: true)
    teaching_request = create(
      :default_teaching_request,
      status: :done,
      lead_instructor: instructor,
      subject_portfolio: nil
    )

    visit staff_manager_teaching_requests_path(sort: TeachingRequest.status.done.text)

    within "##{ActionView::RecordIdentifier.dom_id(teaching_request)}" do
      assert_text 'No lead response recorded'
      click_on 'Add portfolio'
    end
    assert_selector '#portfolio-classification-modal', visible: true

    within '#portfolio-classification-modal' do
      select @subject_portfolio.name, from: 'Subject portfolio'
      click_on 'Save portfolio'
    end

    assert_text 'Request portfolio was updated to Humanities.'
    assert teaching_request.reload.status.done?
    assert_equal instructor, teaching_request.lead_instructor
    assert_equal @subject_portfolio, teaching_request.subject_portfolio
    assert_equal 0, ActionMailer::Base.deliveries.size
    within "##{ActionView::RecordIdentifier.dom_id(teaching_request)}" do
      assert_text 'No lead response recorded'
    end
  end

  test 'adding a portfolio does not hide an awaiting legacy lead response' do
    instructor = create(:user, is_active: true)
    create(:staff_profile, user: instructor, role: :staff_instructor, is_approved: true)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: instructor,
      subject_portfolio: nil
    )

    visit staff_manager_teaching_requests_path(sort: TeachingRequest.status.in_process.text)

    within "##{ActionView::RecordIdentifier.dom_id(teaching_request)}" do
      assert_text 'Awaiting lead response'
      click_on 'Add portfolio'
    end
    assert_selector '#portfolio-classification-modal', visible: true

    within '#portfolio-classification-modal' do
      select @subject_portfolio.name, from: 'Subject portfolio'
      click_on 'Save portfolio'
    end

    assert_text 'Request portfolio was updated to Humanities.'
    within "##{ActionView::RecordIdentifier.dom_id(teaching_request)}" do
      assert_text 'Awaiting lead response'
    end
    assert teaching_request.reload.status.in_process?
    assert_equal instructor, teaching_request.lead_instructor
    assert_equal @subject_portfolio, teaching_request.subject_portfolio
    assert_empty ActionMailer::Base.deliveries
  end
end
