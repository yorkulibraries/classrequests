class SubjectPortfolio < ApplicationRecord
  has_many :teaching_requests, dependent: :restrict_with_error
  has_many :subject_portfolio_memberships, dependent: :destroy
  has_many :subject_portfolio_declines, dependent: :restrict_with_error
  has_many :members, through: :subject_portfolio_memberships, source: :user

  scope :active, -> { where(active: true) }

  normalizes :name, with: ->(name) { name.strip }
  normalizes :notification_email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :notification_email,
            presence: true,
            length: { maximum: 255 },
            format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/ }

  def eligible_members
    members.merge(User.eligible_for_subject_portfolios)
  end
end
