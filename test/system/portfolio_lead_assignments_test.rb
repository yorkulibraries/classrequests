require "application_system_test_case"

class PortfolioLeadAssignmentsTest < ApplicationSystemTestCase
  teardown do
    Warden.test_reset!
  end

  test "portfolio member claims an awaiting request" do
    member = create(:user, is_active: true)
    create(:staff_profile, user: member, role: :staff_instructor, is_approved: true)
    subject_portfolio = create(:subject_portfolio, name: "Humanities")
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: member)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    other_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: create(:subject_portfolio, name: "Business"),
      lead_instructor: nil
    )
    ActionMailer::Base.deliveries.clear
    sign_in member

    visit staff_dashboard_path

    within "#portfolio-assignment-queue" do
      assert_text subject_portfolio.name
      assert_text teaching_request.name
      assert_no_selector "##{ActionView::RecordIdentifier.dom_id(other_request, :portfolio_queue)}"
      click_on "Claim request"
    end
    within ".modal" do
      click_on "Confirm"
    end

    assert_text "The request was assigned to you as lead instructor."
    assert_equal member, teaching_request.reload.lead_instructor
    assert teaching_request.status.assigned?
    assert_equal 2, ActionMailer::Base.deliveries.size
  end

  test "manager assigns an awaiting request to a portfolio member" do
    manager = create(:user, is_active: true)
    create(:staff_profile, user: manager, role: :manager, is_approved: true)
    member = create(:user, is_active: true)
    create(:staff_profile, user: member, role: :staff_instructor, is_approved: true)
    subject_portfolio = create(:subject_portfolio, name: "Social Sciences")
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: member)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    ActionMailer::Base.deliveries.clear
    sign_in manager

    visit staff_manager_dashboard_path

    within "#portfolio-assignment-queue" do
      assert_text subject_portfolio.name
      click_on "Select lead"
    end
    assert_selector "#portfolio-lead-assignment-modal", visible: true

    within "#portfolio-lead-assignment-modal" do
      select member.full_name, from: "Portfolio member"
      click_on "Confirm portfolio lead"
    end

    assert_text "#{member.full_name} was confirmed as the portfolio lead.", wait: 10
    assert_equal member, teaching_request.reload.lead_instructor
    assert teaching_request.status.assigned?
    assert_equal 3, ActionMailer::Base.deliveries.size
  end

  test "portfolio member returns an unclaimed request to the manager" do
    member = create(:user, is_active: true)
    create(:staff_profile, user: member, role: :staff_instructor, is_approved: true)
    subject_portfolio = create(:subject_portfolio, name: "Health Sciences")
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: member)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    ActionMailer::Base.deliveries.clear
    sign_in member

    visit staff_dashboard_path

    within "#portfolio-assignment-queue" do
      click_on "Return to manager"
    end
    assert_selector "#subject-portfolio-decline-modal", visible: true

    within "#subject-portfolio-decline-modal" do
      fill_in "Reason for returning the request",
              with: "No portfolio member is available on the requested date."
      check "Return this request to the manager and remove its current portfolio assignment?"
      click_on "Return to manager"
    end

    assert_text "The request was returned to the manager for reassignment.", wait: 10
    assert teaching_request.reload.status.new_request?
    assert_nil teaching_request.subject_portfolio
    assert_equal 1, teaching_request.subject_portfolio_declines.count
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end
