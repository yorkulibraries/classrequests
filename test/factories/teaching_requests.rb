FactoryBot.define do

  factory :new_requests_by_users, class: TeachingRequest do
  end

  factory :new_request, class: TeachingRequest do
  end
  
  # factory :user do
  #   first_name { 'John' }
  #   last_name { 'Doe' }
  #   email { 'john.doe@example.com' }
  # end

  factory :valid_teaching_request, class: 'TeachingRequest' do
    association :user, factory: :user

    patron_type { :faculty }
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'johndoe@example.com' }
    association :campus_location, factory: :valid_campus_location
    academic_year { '2023' }
    faculty_abbrev { 'ABC' }
    subject_abbrev { 'DEF' }
    course_number { '101' }
    course_title { 'Introduction to Valid Course' }
    status { :not_submitted }
    number_of_students { 30 }
    preferred_date { Date.today }
    preferred_time { Time.now }
    duration { :sixty }
    location_preference { :to_be_determined }
    request_note { 'Sample request note' }
  end

  factory :default_teaching_request, class: 'TeachingRequest' do
    association :user, factory: :user

    patron_type { :faculty }
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'johndoe@example.com' }
    association :campus_location, factory: :valid_campus_location
    academic_year { '2023' }
    faculty_abbrev { 'ABC' }
    subject_abbrev { 'DEF' }
    course_number { '101' }
    course_title { 'Introduction to 101' }
    status { 0 }
    number_of_students { 30 }
    preferred_date { Date.today }
    preferred_time { Time.now }
    duration { :sixty }
    location_preference { :to_be_determined }
    request_note { 'Sample request note' }
  end
end
