FactoryBot.define do
  factory :staff_profile do
    association :department
    association :user
    role { :staff_instructor }
    is_approved { true }
  end
end
