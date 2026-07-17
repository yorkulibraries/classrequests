require "test_helper"

class StaffMailerTest < ActionMailer::TestCase
  setup do
    @lead_instructor = FactoryBot.create(
      :librarian_jane_doe,
      email: "instructor@example.com",
      first_name: "Jane",
      last_name: "Doe"
    )

    @request = FactoryBot.create(
      :default_teaching_request,
      lead_instructor: @lead_instructor,
      status: :in_process
    )
  end

  test "assign instructor email renders with settings defaults" do
    mail = StaffMailer.assign_instructor_for_request(@request, @lead_instructor.email)

    assert_equal [@lead_instructor.email], mail.to
    assert_equal "Class Lead Assignment: Library Class Request", mail.subject
    assert_includes mail.body.encoded, @lead_instructor.first_name
    assert mail.attachments[Setting.mail_logo_url], "expected inline mail logo attachment"
  end
end