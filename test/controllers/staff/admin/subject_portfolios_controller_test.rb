require "test_helper"

class Staff::Admin::SubjectPortfoliosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = create(:user, is_active: true)
    create(:staff_profile, user: @admin, role: :administrator, is_approved: true)
    sign_in @admin
  end

  test "administrator can view subject portfolios" do
    subject_portfolio = create(:subject_portfolio, name: "Humanities")

    get staff_admin_subject_portfolios_path

    assert_response :success
    assert_select "##{ActionView::RecordIdentifier.dom_id(subject_portfolio)}", text: /Humanities/
  end

  test "unauthenticated user is redirected to sign in" do
    sign_out @admin

    get staff_admin_subject_portfolios_path

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "non-administrator receives forbidden response" do
    sign_out @admin
    staff_user = create(:user, is_active: true)
    create(:staff_profile, user: staff_user, role: :staff_instructor, is_approved: true)
    sign_in staff_user

    get staff_admin_subject_portfolios_path

    assert_response :forbidden
  end

  test "administrator can create a subject portfolio" do
    assert_difference("SubjectPortfolio.count", 1) do
      post staff_admin_subject_portfolios_path, params: {
        subject_portfolio: {
          name: "Humanities",
          notification_email: "humanities@example.com",
          active: true
        }
      }
    end

    subject_portfolio = SubjectPortfolio.order(:created_at).last
    assert_redirected_to staff_admin_subject_portfolio_path(id: subject_portfolio.id, locale: :en)
    assert_equal "Humanities", subject_portfolio.name
  end

  test "invalid subject portfolio is not created" do
    assert_no_difference("SubjectPortfolio.count") do
      post staff_admin_subject_portfolios_path, params: {
        subject_portfolio: { name: "", notification_email: "invalid", active: true }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".subject_portfolio_name .invalid-feedback"
  end

  test "administrator can update a subject portfolio" do
    subject_portfolio = create(:subject_portfolio, name: "Humanities")

    patch staff_admin_subject_portfolio_path(id: subject_portfolio.id), params: {
      subject_portfolio: {
        name: "Arts and Humanities",
        notification_email: "arts-humanities@example.com",
        active: false
      }
    }

    assert_response :redirect
    assert_equal "Arts and Humanities", subject_portfolio.reload.name
    assert_equal "arts-humanities@example.com", subject_portfolio.notification_email
    assert_not subject_portfolio.active?
  end

  test "administrator can delete an unused subject portfolio" do
    subject_portfolio = create(:subject_portfolio)
    member = create_eligible_staff_user
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: member)

    assert_difference("SubjectPortfolio.count", -1) do
      assert_difference("SubjectPortfolioMembership.count", -1) do
        assert_no_difference("User.count") do
          delete staff_admin_subject_portfolio_path(id: subject_portfolio.id)
        end
      end
    end

    assert_response :see_other
    assert User.exists?(member.id)
  end

  test "subject portfolio with teaching requests cannot be deleted" do
    subject_portfolio = create(:subject_portfolio)
    membership = SubjectPortfolioMembership.create!(
      subject_portfolio: subject_portfolio,
      user: create_eligible_staff_user
    )
    create(:default_teaching_request, subject_portfolio: subject_portfolio)

    assert_no_difference("SubjectPortfolio.count") do
      delete staff_admin_subject_portfolio_path(id: subject_portfolio.id)
    end

    assert_response :see_other
    assert SubjectPortfolio.exists?(subject_portfolio.id)
    assert SubjectPortfolioMembership.exists?(membership.id)
    assert_equal I18n.t('subject_portfolios.notices.in_use'), flash[:alert]
  end

  private

  def create_eligible_staff_user
    user = create(:user, is_active: true)
    create(:staff_profile, user: user, role: :staff_instructor, is_approved: true)
    user
  end
end
