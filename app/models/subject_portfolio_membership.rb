class SubjectPortfolioMembership < ApplicationRecord
  belongs_to :subject_portfolio
  belongs_to :user

  validates :user_id,
            uniqueness: {
              scope: :subject_portfolio_id,
              message: "is already a member of this subject portfolio"
            }
  validate :user_is_eligible_for_subject_portfolios

  private

  def user_is_eligible_for_subject_portfolios
    return if user.blank? || user.eligible_for_subject_portfolios?

    errors.add(:user, "must be an active, approved staff member with an eligible role")
  end
end
