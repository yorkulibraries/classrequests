require "test_helper"

class Staff::Manager::TeachingRequestsControllerTest < ActionDispatch::IntegrationTest
  test "manager filters teaching requests by cancelled status" do
    manager = create(:user, is_active: true)
    create(:staff_profile, user: manager, role: :manager, is_approved: true)
    cancelled_request = create(:default_teaching_request, status: :cancelled)
    deleted_request = create(:default_teaching_request, status: :deleted)
    sign_in manager

    get staff_manager_teaching_requests_path(sort: TeachingRequest.status.cancelled.text)

    assert_response :success
    assert_select "#teaching_request_#{cancelled_request.id}"
    assert_select "#teaching_request_#{deleted_request.id}", count: 0
    assert_includes response.body, "Cancelled"
  end

  test "manager sees portfolio return audit on request details" do
    manager = create(:user, is_active: true)
    create(:staff_profile, user: manager, role: :manager, is_approved: true)
    member = create(:user, is_active: true)
    create(:staff_profile, user: member, role: :staff_instructor, is_approved: true)
    subject_portfolio = create(:subject_portfolio, name: "Humanities")
    SubjectPortfolioMembership.create!(subject_portfolio: subject_portfolio, user: member)
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      subject_portfolio: subject_portfolio,
      lead_instructor: nil
    )
    decline = SubjectPortfolioDecline.new(
      declined_by: member,
      reason: "The portfolio cannot cover the requested date.",
      confirmed: true
    )
    assert teaching_request.return_portfolio_to_manager(decline)
    sign_in manager

    get staff_manager_teaching_request_path(id: teaching_request.id)

    assert_response :success
    assert_select "#subject-portfolio-decline-history" do
      assert_select "td", text: subject_portfolio.name
      assert_select "td", text: member.full_name
      assert_select "td", text: /portfolio cannot cover/
    end
  end
end
