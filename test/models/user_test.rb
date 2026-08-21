require "test_helper"

class UserTest < ActiveSupport::TestCase
  should have_many(:subject_portfolio_memberships).dependent(:destroy)
  should have_many(:subject_portfolios).through(:subject_portfolio_memberships)
  should have_many(:subject_portfolio_declines)
    .with_foreign_key(:declined_by_id)
    .dependent(:restrict_with_error)

  test "eligible subject portfolio scope includes only active approved eligible staff" do
    eligible_user = create(:user, is_active: true)
    create(:staff_profile, user: eligible_user, role: :manager, is_approved: true)

    inactive_user = create(:user, is_active: false)
    create(:staff_profile, user: inactive_user, role: :staff_instructor, is_approved: true)

    unapproved_user = create(:user, is_active: true)
    create(:staff_profile, user: unapproved_user, role: :staff_instructor, is_approved: false)

    ineligible_role_user = create(:user, is_active: true)
    create(:staff_profile, user: ineligible_role_user, role: :student_staff, is_approved: true)

    assert_equal [eligible_user], User.eligible_for_subject_portfolios.to_a
  end
end
