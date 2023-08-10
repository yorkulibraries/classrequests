FactoryBot.define do

  factory :institute_course, class: 'InstituteCourse' do 
    sequence(:id, 100) { |n| n }
    faculty { 'Faculty of Liberal Arts and Professional Studies' }
    faculty_abbrev { 'AP' }
    subject { 'Administrative Studies' }
    subject_abbrev { 'ADMS' }
    academic_year { ['2020-2021', '2021-2022', '2022-2023'].sample }
    number { Faker::Number.number(digits: 4) }
  end

  factory :first_course, class: 'InstituteCourse' do
    sequence(:id, 200) { |n| n }
    faculty { 'Faculty of Liberal Arts and Professional Studies' }
    faculty_abbrev { 'AP' }
    subject { 'Administrative Studies' }
    subject_abbrev { 'ADMS' }
    academic_year { ['2020-2021', '2021-2022', '2022-2023'].sample }
    number { Faker::Number.number(digits: 4) }
  end
  factory :second_course, class: 'InstituteCourse' do
    sequence(:id, 300) { |n| n }
    faculty { 'Faculty of Liberal Arts and Professional Studies' }
    faculty_abbrev { 'AP' }
    subject { 'Linguistics' }
    subject_abbrev { 'LING' }
    academic_year { ['2020-2021', '2021-2022', '2022-2023'].sample }
    number { Faker::Number.number(digits: 4) }
  end
  factory :third_course, class: 'InstituteCourse' do
    sequence(:id, 400) { |n| n }
    faculty { 'Faculty of Education'}
    faculty_abbrev { 'ED' }
    subject { 'Education' }
    subject_abbrev { 'EDUC' }
    academic_year { ['2020-2021', '2021-2022', '2022-2023'].sample }
    number { Faker::Number.number(digits: 4) }
  end

  # factory :institute_course, class: 'InstituteCourse' do
  #   sequence(:id)
  #   faculty { ['Faculty of Liberal Arts and Professional Studies', 'Faculty of Science', 'Faculty of Education', 'OTHER'].sample  }

  #   after(:build) do |fac|
  #   # faculty do |fac|
  #     if fac.faculty == 'Faculty of Liberal Arts and Professional Studies'
  #       faculty_abbrev = 'AP'
  #       subject { ['Administrative Studies', 'Linguistics', 'Persian'].sample }
  #       subject do |sub|
  #         if sub.subject = 'Administrative Studies'
  #           subject_abbrev = 'ADMS'
  #         elsif sub.subject = 'Linguistics'
  #           subject_abbrev = 'LING'
  #         elsif sub.subject = 'Persian'
  #           subject_abbrev = 'PERS'
  #         else
  #           subject_abbrev = 'OTHR'
  #         end
  #       end
  #     elsif fac.faculty == 'Faculty of Science'
  #       faculty_abbrev = 'SC'
  #       subject { ['Natural Science', 'Physics', 'Seneca'].sample }
  #       subject do |sub|
  #         if sub.subject = 'Natural Science'
  #           subject_abbrev = 'NATS'
  #         elsif sub.subject = 'Physics'
  #           subject_abbrev = 'PHYS'
  #         elsif sub.subject = 'Seneca'
  #           subject_abbrev = 'SENE'
  #         else
  #           subject_abbrev = 'OTHR'
  #         end
  #       end
  #     elsif fac.faculty == 'Faculty of Education'
  #       faculty_abbrev = 'ED'
  #       subject { ['International Exchange', 'Education', 'Foundations'].sample }
  #       subject do |sub|
  #         if sub.subject = 'International Exchange'
  #           subject_abbrev = 'INEX'
  #         elsif sub.subject = 'Education'
  #           subject_abbrev = 'EDUC'
  #         elsif sub.subject = 'Foundations'
  #           subject_abbrev = 'EDFE'
  #         else
  #           subject_abbrev = 'OTHR'
  #         end
  #       end
  #     else 
  #       faculty_abbrev 'OTHER'
  #       subject { 'Other' }
  #       subject_abbrev {'OTHR'}
  #     end
  #   end
  #   academic_year { ['2020-2021', '2021-2022', '2022-2023'].sample }
  #   number { Faker::Number.number(digits: 4) }
  #   # Add other attributes as needed
  # end


  # academic_years = ['2020-2021', '2021-2022', '2022-2023']

end