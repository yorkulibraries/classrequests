require "test_helper"

class Staff::AssignmentResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = create(:user, is_active: true)
    create(:staff_profile, user: @member, role: :staff_instructor, is_approved: true)
    @subject_portfolio = create(:subject_portfolio, name: "Humanities")
    SubjectPortfolioMembership.create!(subject_portfolio: @subject_portfolio, user: @member)
    @teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: @subject_portfolio,
      lead_instructor: @member
    )

    ActionMailer::Base.deliveries.clear
    sign_in @member
  end

  test "proposed portfolio lead accepts and confirms the request" do
    assert_difference "AssignmentResponse.count", 1 do
      assert_emails 2 do
        post staff_teaching_request_assignment_responses_path(
          teaching_request_id: @teaching_request.id
        ), params: {
          assignment_response: {
            response: :accept,
            comment_or_reason: "I can lead this class."
          }
        }
      end
    end

    assert_redirected_to staff_dashboard_path(
      locale: :en,
      sort: TeachingRequest.status.assigned.text
    )
    assert @teaching_request.reload.status.assigned?
    assert_equal @member, @teaching_request.lead_instructor
  end

  test "proposed portfolio lead declines and returns request to portfolio queue" do
    assert_difference "AssignmentResponse.count", 1 do
      assert_emails 1 do
        post staff_teaching_request_assignment_responses_path(
          teaching_request_id: @teaching_request.id
        ), params: {
          assignment_response: {
            response: :decline,
            comment_or_reason: "The requested date conflicts with another class."
          }
        }
      end
    end

    assert @teaching_request.reload.status.in_process?
    assert_nil @teaching_request.lead_instructor
    assert_equal @subject_portfolio, @teaching_request.subject_portfolio
    assert_includes TeachingRequest.awaiting_portfolio_lead, @teaching_request
    assert_equal Setting.manager_emails, ActionMailer::Base.deliveries.last.to
  end

  test "staff member who is not the selected lead cannot respond" do
    sign_out @member
    outsider = create(:user, is_active: true)
    create(:staff_profile, user: outsider, role: :staff_instructor, is_approved: true)
    sign_in outsider

    assert_no_difference "AssignmentResponse.count" do
      assert_no_emails do
        post staff_teaching_request_assignment_responses_path(
          teaching_request_id: @teaching_request.id
        ), params: {
          assignment_response: { response: :accept }
        }
      end
    end

    assert_response :forbidden
    assert @teaching_request.reload.status.in_process?
    assert_equal @member, @teaching_request.lead_instructor
  end
end
