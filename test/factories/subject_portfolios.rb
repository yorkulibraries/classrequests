FactoryBot.define do
  factory :subject_portfolio do
    sequence(:name) { |number| "Subject Portfolio #{number}" }
    sequence(:notification_email) { |number| "portfolio#{number}@example.com" }
    active { true }
  end
end
