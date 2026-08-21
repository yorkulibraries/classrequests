class SubjectPortfolioDecline < ApplicationRecord
  attribute :confirmed, :boolean, default: false

  belongs_to :teaching_request
  belongs_to :subject_portfolio
  belongs_to :declined_by, class_name: "User", inverse_of: :subject_portfolio_declines

  validates :reason, presence: true, length: { maximum: 2_000 }
  validates :confirmed, acceptance: true, on: :create
end
