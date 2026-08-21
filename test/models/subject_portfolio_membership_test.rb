require "test_helper"

class SubjectPortfolioMembershipTest < ActiveSupport::TestCase
  should belong_to(:subject_portfolio)
  should belong_to(:user)

  test "allows an active and approved staff instructor" do
    user = create_eligible_user
    membership = SubjectPortfolioMembership.new(
      subject_portfolio: create(:subject_portfolio),
      user: user
    )

    assert membership.valid?
  end

  test "rejects duplicate membership" do
    user = create_eligible_user
    subject_portfolio = create(:subject_portfolio)
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: user)
    duplicate = SubjectPortfolioMembership.new(subject_portfolio: subject_portfolio, user: user)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "is already a member of this subject portfolio"
  end

  test "rejects an inactive user" do
    user = create_eligible_user(is_active: false)
    membership = SubjectPortfolioMembership.new(
      subject_portfolio: create(:subject_portfolio),
      user: user
    )

    assert_not membership.valid?
    assert_includes membership.errors[:user], "must be an active, approved staff member with an eligible role"
  end

  test "rejects an unapproved staff profile" do
    user = create_eligible_user(is_approved: false)
    membership = SubjectPortfolioMembership.new(
      subject_portfolio: create(:subject_portfolio),
      user: user
    )

    assert_not membership.valid?
    assert_includes membership.errors[:user], "must be an active, approved staff member with an eligible role"
  end

  test "rejects an ineligible staff role" do
    user = create_eligible_user(role: :student_staff)
    membership = SubjectPortfolioMembership.new(
      subject_portfolio: create(:subject_portfolio),
      user: user
    )

    assert_not membership.valid?
    assert_includes membership.errors[:user], "must be an active, approved staff member with an eligible role"
  end

  private

  def create_eligible_user(is_active: true, is_approved: true, role: :staff_instructor)
    user = create(:user, is_active: is_active)
    create(:staff_profile, user: user, is_approved: is_approved, role: role)
    user
  end
end
