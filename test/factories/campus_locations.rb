FactoryBot.define do
   factory :valid_campus_location, class: 'CampusLocation' do
      sequence(:name) { |number| "Test Campus #{number}" }
      address {"4700 Keele Street"} 
   end
end
