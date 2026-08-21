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

  test "portfolio member assignment renders the assignee and portfolio" do
    subject_portfolio = create(:subject_portfolio, name: "Humanities")
    @request.update!(
      subject_portfolio: subject_portfolio,
      status: :assigned
    )

    mail = StaffMailer.portfolio_member_assignment(@request)

    assert_equal [@lead_instructor.email], mail.to
    assert_equal "Library Class Request Assigned to You", mail.subject
    assert_includes mail.html_part.body.encoded, @lead_instructor.first_name
    assert_includes mail.html_part.body.encoded, subject_portfolio.name
    assert_includes mail.text_part.body.encoded, @request.course_number.to_s
    assert mail.attachments[Setting.mail_logo_url], "expected inline mail logo attachment"
  end

  test "portfolio lead confirmation notifies managers" do
    subject_portfolio = create(:subject_portfolio, name: "Humanities")
    manager = create(:user, first_name: "Morgan", last_name: "Manager")
    @request.update!(subject_portfolio: subject_portfolio, status: :assigned)

    mail = StaffMailer.portfolio_lead_confirmed(@request, manager)

    assert_equal Setting.manager_emails, mail.to
    assert_equal "Library Class Request Lead Confirmed", mail.subject
    assert_includes mail.html_part.body.encoded, @lead_instructor.full_name
    assert_includes mail.html_part.body.encoded, manager.full_name
    assert_includes mail.text_part.body.encoded, subject_portfolio.name
  end

  test "portfolio return email includes its audit details for managers" do
    subject_portfolio = create(:subject_portfolio, name: "Social Sciences")
    member = create(:user, first_name: "Pat", last_name: "Portfolio")
    decline = create(
      :subject_portfolio_decline,
      teaching_request: @request,
      subject_portfolio: subject_portfolio,
      declined_by: member,
      reason: "No one is available on the requested date."
    )

    mail = StaffMailer.portfolio_assignment_returned(decline)

    assert_equal Setting.manager_emails, mail.to
    assert_equal "Library Class Request Returned by Portfolio", mail.subject
    assert_includes mail.html_part.body.encoded, member.full_name
    assert_includes mail.html_part.body.encoded, decline.reason
    assert_includes mail.text_part.body.encoded, subject_portfolio.name
  end
end
