require "test_helper"

class IntroLibraryResearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  should enumerize(:patron_type).in(faculty: 0, librarian_staff: 1, other: 9).with_default(:other)
  should enumerize(:status).in(not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, deleted: 9).with_default(:not_submitted)

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

  ## EMAILS
  should allow_value('test@example.com', 'another@test.com').for(:email)
  should_not allow_value('invalid_email', 'test@').for(:email)

end
