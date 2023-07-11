require "test_helper"

class TeachingRequestTest < ActiveSupport::TestCase


  ## ENUMS
  # should define_enum_for(:status).with_values(... doesn't work... use enmuerize) 

  should enumerize(:patron_type).in(faculty: 0, librarian_staff: 1, other: 9).with_default(:other)
  should enumerize(:status).in(not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, deleted: 9).with_default(:not_submitted)

  should enumerize(:duration).in(thirty: '30', sixty: '60', sixty_plus: '60+', ninety: '90', one_twenty: '120', one_eighty: '180', one_eighty_plus: '180+')

  should enumerize(:location_preference).in(:online, :pre_recorded, :in_the_class, :in_the_library, :off_campus, :to_be_determined).with_default(:to_be_determined)

  ## PRESENCE
  should validate_presence_of(:patron_type)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)
  should validate_presence_of(:academic_year)
  should validate_presence_of(:faculty_abbrev)
  should validate_presence_of(:subject_abbrev)
  should validate_presence_of(:course_number)
  should validate_presence_of(:status)
  should validate_presence_of(:number_of_students)
  should validate_presence_of(:preferred_date)
  should validate_presence_of(:preferred_time)
  should validate_presence_of(:duration)
  should validate_presence_of(:location_preference)
  should validate_presence_of(:request_note)

  ## EMAILS
  should allow_value('test@example.com', 'another@test.com').for(:email)
  should_not allow_value('invalid_email', 'test@').for(:email)


  ## CONDITION VALIDATION ON LEAD ONLY IF TR IS IN PROCESS STATUS
  test 'lead_instructor_id presence validation when status is in_process' do
    teaching_request = TeachingRequest.new(status: 2)
    teaching_request.lead_instructor_id = nil
    # puts teaching_request.status.inspect
    assert_not teaching_request.valid?
    assert_equal ["can't be blank"], teaching_request.errors[:lead_instructor_id]
  end

  test 'default status value' do
    teaching_request = TeachingRequest.new
    teaching_request = FactoryBot.create(:default_teaching_request)
    # puts "TeachingRequest Status: #{teaching_request.status}" 
    ## Test if default status is not_submitted.
    assert_equal 0, teaching_request.status
    # puts teaching_request.inspect
  end

end
