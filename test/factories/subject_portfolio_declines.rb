FactoryBot.define do
  factory :subject_portfolio_decline do
    association :teaching_request, factory: :default_teaching_request
    subject_portfolio
    association :declined_by, factory: :user
    reason { "The portfolio does not have capacity for the requested date." }
    confirmed { true }
  end
end
