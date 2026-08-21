require "test_helper"

class Staff::PortfolioClaimsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = create(:user, is_active: true)
    create(:staff_profile, user: @member, role: :staff_instructor, is_approved: true)
    @subject_portfolio = create(:subject_portfolio, name: "Humanities")
    SubjectPortfolioMembership.create!(
      subject_portfolio: @subject_portfolio,
      user: @member
    )
    @teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: @subject_portfolio,
      lead_instructor: nil
    )

    ActionMailer::Base.deliveries.clear
    sign_in @member
  end

  test "portfolio member claims a request and the requestor and managers are notified" do
    assert_emails 2 do
      patch staff_portfolio_claim_path(id: @teaching_request.id)
    end

    assert_redirected_to staff_dashboard_path(locale: :en)
    assert_equal @member, @teaching_request.reload.lead_instructor
    assert @teaching_request.status.assigned?
    recipients = ActionMailer::Base.deliveries.flat_map(&:to)
    assert_includes recipients, @teaching_request.email
    Setting.manager_emails.each { |email| assert_includes recipients, email }
  end

  test "nonmember cannot claim a portfolio request" do
    sign_out @member
    nonmember = create(:user, is_active: true)
    create(:staff_profile, user: nonmember, role: :staff_instructor, is_approved: true)
    sign_in nonmember

    assert_no_emails do
      patch staff_portfolio_claim_path(id: @teaching_request.id)
    end

    assert_redirected_to staff_dashboard_path(locale: :en)
    assert_nil @teaching_request.reload.lead_instructor
    assert @teaching_request.status.in_process?
    assert_includes flash[:alert], I18n.t('subject_portfolios.claim.errors.ineligible')
  end

  test "request cannot be claimed or notified twice" do
    patch staff_portfolio_claim_path(id: @teaching_request.id)

    assert_no_emails do
      patch staff_portfolio_claim_path(id: @teaching_request.id)
    end

    assert_equal 2, ActionMailer::Base.deliveries.size
    assert_equal @member, @teaching_request.reload.lead_instructor
  end

  test "unauthenticated user is redirected to sign in" do
    sign_out @member

    patch staff_portfolio_claim_path(id: @teaching_request.id)

    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_nil @teaching_request.reload.lead_instructor
  end
end
