FactoryBot.define do
  factory :department do
    sequence(:name) { |number| "Department #{number}" }
    branch_division { "Library" }
  end
end
