require 'test_helper'

class Staff::Manager::PortfolioClassificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create(:user, is_active: true)
    create(:staff_profile, user: @manager, role: :manager, is_approved: true)
    @subject_portfolio = create(
      :subject_portfolio,
      name: 'Humanities',
      notification_email: 'humanities@example.com'
    )
    @inactive_subject_portfolio = create(
      :subject_portfolio,
      name: 'Retired Portfolio',
      active: false
    )
    @instructors = 3.times.map do
      user = create(:user, is_active: true)
      create(:staff_profile, user: user, role: :staff_instructor, is_approved: true)
      SubjectPortfolioMembership.create!(subject_portfolio: @subject_portfolio, user: user)
      user
    end
    @teaching_request = create(
      :default_teaching_request,
      status: :done,
      lead_instructor: @instructors[0],
      second_instructor: @instructors[1],
      third_instructor: @instructors[2],
      subject_portfolio: nil
    )

    ActionMailer::Base.deliveries.clear
    sign_in @manager
  end

  test 'manager can open portfolio management for a historical request' do
    get edit_staff_manager_portfolio_classification_path(id: @teaching_request.id)

    assert_response :success
    assert_includes response.body, @subject_portfolio.name
    assert_not_includes response.body, @inactive_subject_portfolio.name
    @instructors.each { |instructor| assert_includes response.body, instructor.full_name }
  end

  test 'manager classifies completed work without changing instructors or sending email' do
    original_instructor_ids = [
      @teaching_request.lead_instructor_id,
      @teaching_request.second_instructor_id,
      @teaching_request.third_instructor_id
    ]

    assert_no_emails do
      patch staff_manager_portfolio_classification_path(id: @teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: @subject_portfolio.id }
      }
    end

    @teaching_request.reload
    assert_response :redirect
    assert @teaching_request.status.done?
    assert_equal @subject_portfolio, @teaching_request.subject_portfolio
    assert_equal original_instructor_ids, [
      @teaching_request.lead_instructor_id,
      @teaching_request.second_instructor_id,
      @teaching_request.third_instructor_id
    ]
  end

  test 'manager classifies a new request and notifies the portfolio' do
    teaching_request = create(
      :default_teaching_request,
      status: :new_request,
      lead_instructor: nil,
      subject_portfolio: nil
    )

    assert_emails 1 do
      patch staff_manager_portfolio_classification_path(id: teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: @subject_portfolio.id }
      }
    end

    teaching_request.reload
    assert teaching_request.status.in_process?
    assert_equal @subject_portfolio, teaching_request.subject_portfolio
    assert_equal [@subject_portfolio.notification_email], ActionMailer::Base.deliveries.last.to
  end

  test 'manager can remove a portfolio from unclaimed work' do
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: nil,
      subject_portfolio: @subject_portfolio
    )

    assert_no_emails do
      patch staff_manager_portfolio_classification_path(id: teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: '' }
      }
    end

    teaching_request.reload
    assert teaching_request.status.new_request?
    assert_nil teaching_request.subject_portfolio
  end

  test 'saving the same awaiting portfolio does not notify it again' do
    teaching_request = create(
      :default_teaching_request,
      status: :in_process,
      lead_instructor: nil,
      subject_portfolio: @subject_portfolio
    )

    assert_no_emails do
      patch staff_manager_portfolio_classification_path(id: teaching_request.id), params: {
        teaching_request: { subject_portfolio_id: @subject_portfolio.id }
      }
    end

    assert_response :redirect
    assert teaching_request.reload.status.in_process?
    assert_equal @subject_portfolio, teaching_request.subject_portfolio
  end

  test 'inactive portfolio cannot be added to a historical request' do
    patch staff_manager_portfolio_classification_path(id: @teaching_request.id), params: {
      teaching_request: { subject_portfolio_id: @inactive_subject_portfolio.id }
    }

    assert_response :unprocessable_entity
    assert_nil @teaching_request.reload.subject_portfolio
  end

  test 'classification ignores forged status and instructor parameters' do
    forged_instructor = create(:user)

    patch staff_manager_portfolio_classification_path(id: @teaching_request.id), params: {
      teaching_request: {
        subject_portfolio_id: @subject_portfolio.id,
        status: :deleted,
        lead_instructor_id: forged_instructor.id
      }
    }

    @teaching_request.reload
    assert @teaching_request.status.done?
    assert_equal @instructors[0], @teaching_request.lead_instructor
  end

  test 'staff instructor receives a forbidden response' do
    sign_out @manager
    sign_in @instructors[0]

    get edit_staff_manager_portfolio_classification_path(id: @teaching_request.id)

    assert_response :forbidden
  end

  test 'unauthenticated user is redirected to sign in' do
    sign_out @manager

    get edit_staff_manager_portfolio_classification_path(id: @teaching_request.id)

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end
