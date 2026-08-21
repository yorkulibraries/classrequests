require "test_helper"

class SubjectPortfolioTest < ActiveSupport::TestCase
  should have_many(:subject_portfolio_memberships).dependent(:destroy)
  should have_many(:members).through(:subject_portfolio_memberships).source(:user)
  should have_many(:teaching_requests).dependent(:restrict_with_error)
  should have_many(:subject_portfolio_declines).dependent(:restrict_with_error)

  should validate_presence_of(:name)
  should validate_presence_of(:notification_email)

  test "normalizes its name and notification email" do
    subject_portfolio = create(
      :subject_portfolio,
      name: "  Humanities  ",
      notification_email: "  HUMANITIES@EXAMPLE.COM  "
    )

    assert_equal "Humanities", subject_portfolio.name
    assert_equal "humanities@example.com", subject_portfolio.notification_email
  end

  test "requires a unique name regardless of case" do
    create(:subject_portfolio, name: "Humanities")
    duplicate = build(:subject_portfolio, name: "humanities")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "rejects an invalid notification email" do
    subject_portfolio = build(:subject_portfolio, notification_email: "not-an-email")

    assert_not subject_portfolio.valid?
    assert_includes subject_portfolio.errors[:notification_email], "is invalid"
  end

  test "is active by default" do
    assert_predicate SubjectPortfolio.new, :active?
  end

  test "eligible members excludes members who are no longer active or approved" do
    eligible_member = create(:user, is_active: true)
    create(:staff_profile, user: eligible_member, role: :staff_instructor, is_approved: true)
    inactive_member = create(:user, is_active: true)
    create(:staff_profile, user: inactive_member, role: :staff_instructor, is_approved: true)

    SubjectPortfolioMembership.create!(subject_portfolio: subject, user: eligible_member)
    SubjectPortfolioMembership.create!(subject_portfolio: subject, user: inactive_member)
    inactive_member.update!(is_active: false)

    assert_includes subject.eligible_members, eligible_member
    assert_not_includes subject.eligible_members, inactive_member
  end

  private

  def subject
    @subject ||= create(:subject_portfolio)
  end
end
