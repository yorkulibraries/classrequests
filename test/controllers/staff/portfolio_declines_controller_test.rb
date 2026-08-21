require "test_helper"

class Staff::PortfolioDeclinesControllerTest < ActionDispatch::IntegrationTest
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

  test "eligible portfolio member opens the return form" do
    get new_staff_portfolio_decline_path(
      teaching_request_id: @teaching_request.id
    ), xhr: true

    assert_response :success
    assert_includes response.body, "Return portfolio request"
    assert_includes response.body, @subject_portfolio.name
  end

  test "eligible portfolio member returns the request and managers are notified" do
    assert_difference "SubjectPortfolioDecline.count", 1 do
      assert_emails 1 do
        post staff_portfolio_declines_path, params: {
          subject_portfolio_decline: {
            teaching_request_id: @teaching_request.id,
            reason: "No one is available for the requested date.",
            confirmed: "1"
          }
        }
      end
    end

    assert_redirected_to staff_dashboard_path(locale: :en)
    assert @teaching_request.reload.status.new_request?
    assert_nil @teaching_request.subject_portfolio

    decline = SubjectPortfolioDecline.last
    assert_equal @member, decline.declined_by
    assert_equal @subject_portfolio, decline.subject_portfolio
    assert_equal Setting.manager_emails, ActionMailer::Base.deliveries.last.to
  end

  test "blank return reason does not change the request or send email" do
    assert_no_difference "SubjectPortfolioDecline.count" do
      assert_no_emails do
        post staff_portfolio_declines_path, params: {
          subject_portfolio_decline: {
            teaching_request_id: @teaching_request.id,
            reason: "",
            confirmed: "1"
          }
        }
      end
    end

    assert_response :unprocessable_entity
    assert @teaching_request.reload.status.in_process?
    assert_equal @subject_portfolio, @teaching_request.subject_portfolio
  end

  test "unchecked confirmation does not change the request or send email" do
    assert_no_difference "SubjectPortfolioDecline.count" do
      assert_no_emails do
        post staff_portfolio_declines_path, params: {
          subject_portfolio_decline: {
            teaching_request_id: @teaching_request.id,
            reason: "No one is available for the requested date.",
            confirmed: "0"
          }
        }
      end
    end

    assert_response :unprocessable_entity
    assert @teaching_request.reload.status.in_process?
    assert_equal @subject_portfolio, @teaching_request.subject_portfolio
  end

  test "user outside the portfolio cannot return its request" do
    sign_out @member
    outsider = create(:user, is_active: true)
    create(:staff_profile, user: outsider, role: :staff_instructor, is_approved: true)
    sign_in outsider

    assert_no_difference "SubjectPortfolioDecline.count" do
      assert_no_emails do
        post staff_portfolio_declines_path, params: {
          subject_portfolio_decline: {
            teaching_request_id: @teaching_request.id,
            reason: "Not our request",
            confirmed: "1"
          }
        }
      end
    end

    assert_response :unprocessable_entity
    assert @teaching_request.reload.status.in_process?
    assert_equal @subject_portfolio, @teaching_request.subject_portfolio
  end

  test "request cannot be returned after it is claimed" do
    assert @teaching_request.assign_portfolio_lead(@member)

    assert_no_difference "SubjectPortfolioDecline.count" do
      assert_no_emails do
        post staff_portfolio_declines_path, params: {
          subject_portfolio_decline: {
            teaching_request_id: @teaching_request.id,
            reason: "This state is stale",
            confirmed: "1"
          }
        }
      end
    end

    assert_response :unprocessable_entity
    assert @teaching_request.reload.status.assigned?
    assert_equal @member, @teaching_request.lead_instructor
  end

  test "unauthenticated user is redirected to sign in" do
    sign_out @member

    get new_staff_portfolio_decline_path(
      teaching_request_id: @teaching_request.id
    )

    assert_redirected_to new_user_session_path
  end
end
