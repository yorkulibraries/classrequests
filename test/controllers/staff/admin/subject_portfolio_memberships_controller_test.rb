require "test_helper"

class Staff::Admin::SubjectPortfolioMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = create(:user, is_active: true)
    create(:staff_profile, user: @admin, role: :administrator, is_approved: true)
    @subject_portfolio = create(:subject_portfolio)
    @eligible_user = create_eligible_staff_user
    sign_in @admin
  end

  test "administrator can add an eligible portfolio member" do
    assert_difference("SubjectPortfolioMembership.count", 1) do
      post staff_admin_subject_portfolio_subject_portfolio_memberships_path(
             subject_portfolio_id: @subject_portfolio.id
           ),
           params: { subject_portfolio_membership: { user_id: @eligible_user.id } }
    end

    assert_response :redirect
    assert_includes @subject_portfolio.reload.members, @eligible_user
  end

  test "ineligible user cannot be added to a portfolio" do
    ineligible_user = create(:user, is_active: true)

    assert_no_difference("SubjectPortfolioMembership.count") do
      post staff_admin_subject_portfolio_subject_portfolio_memberships_path(
             subject_portfolio_id: @subject_portfolio.id
           ),
           params: { subject_portfolio_membership: { user_id: ineligible_user.id } }
    end

    assert_response :redirect
    assert_match "must be an active, approved staff member", flash[:alert]
  end

  test "duplicate portfolio member cannot be added" do
    SubjectPortfolioMembership.create!(
      subject_portfolio: @subject_portfolio,
      user: @eligible_user
    )

    assert_no_difference("SubjectPortfolioMembership.count") do
      post staff_admin_subject_portfolio_subject_portfolio_memberships_path(
             subject_portfolio_id: @subject_portfolio.id
           ),
           params: { subject_portfolio_membership: { user_id: @eligible_user.id } }
    end

    assert_response :redirect
    assert_match "already a member", flash[:alert]
  end

  test "administrator can remove a portfolio member without deleting the user" do
    membership = SubjectPortfolioMembership.create!(
      subject_portfolio: @subject_portfolio,
      user: @eligible_user
    )

    assert_difference("SubjectPortfolioMembership.count", -1) do
      assert_no_difference("User.count") do
        delete staff_admin_subject_portfolio_subject_portfolio_membership_path(
          subject_portfolio_id: @subject_portfolio.id,
          id: membership.id
        )
      end
    end

    assert_response :see_other
    assert User.exists?(@eligible_user.id)
  end

  test "non-administrator cannot add a portfolio member" do
    sign_out @admin
    staff_user = create_eligible_staff_user
    sign_in staff_user

    assert_no_difference("SubjectPortfolioMembership.count") do
      post staff_admin_subject_portfolio_subject_portfolio_memberships_path(
             subject_portfolio_id: @subject_portfolio.id
           ),
           params: { subject_portfolio_membership: { user_id: @eligible_user.id } }
    end

    assert_response :forbidden
  end

  private

  def create_eligible_staff_user
    user = create(:user, is_active: true)
    create(:staff_profile, user: user, role: :staff_instructor, is_approved: true)
    user
  end
end
