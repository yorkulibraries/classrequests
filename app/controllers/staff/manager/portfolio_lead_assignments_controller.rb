class Staff::Manager::PortfolioLeadAssignmentsController < Staff::Manager::BaseController
  ASSIGNMENT_MODES = %w[confirmed acceptance_required].freeze

  before_action :set_teaching_request
  before_action :set_eligible_members

  def edit
    return if @teaching_request.portfolio_claimable?

    assignment_unavailable
  end

  def update
    assignee = @eligible_members.find_by(id: assignment_params[:lead_instructor_id])

    if assignee.nil?
      @teaching_request.errors.add(
        :lead_instructor,
        t('subject_portfolios.claim.errors.ineligible')
      )
      return assignment_failed
    end

    unless ASSIGNMENT_MODES.include?(assignment_mode)
      @teaching_request.errors.add(
        :base,
        t('subject_portfolios.claim.errors.invalid_mode')
      )
      return assignment_failed
    end

    if assign_lead(assignee)
      notify_assignment(assignee)
      assignment_succeeded
    else
      assignment_failed
    end
  end

  private

  def set_teaching_request
    @teaching_request = TeachingRequest.find(params[:id])
  end

  def set_eligible_members
    @eligible_members = if @teaching_request.subject_portfolio
                          @teaching_request.subject_portfolio.eligible_members.order(:first_name, :last_name)
                        else
                          User.none
                        end
  end

  def assignment_params
    params.require(:teaching_request).permit(:lead_instructor_id)
  end

  def assignment_mode
    params[:assignment_mode].presence || 'confirmed'
  end

  def assign_lead(assignee)
    if assignment_mode == 'acceptance_required'
      @teaching_request.request_portfolio_lead_acceptance(assignee)
    else
      @teaching_request.assign_portfolio_lead(assignee)
    end
  end

  def notify_assignment(assignee)
    if assignment_mode == 'acceptance_required'
      StaffMailer.assign_instructor_for_request(@teaching_request, assignee.email).deliver_now
    else
      StaffMailer.portfolio_member_assignment(@teaching_request).deliver_now
      RequestorMailer.request_assignment(@teaching_request).deliver_now
      StaffMailer.portfolio_lead_confirmed(@teaching_request, current_user).deliver_now
    end
  end

  def assignment_succeeded
    notice_key = if assignment_mode == 'acceptance_required'
                   'subject_portfolios.claim.notices.acceptance_requested'
                 else
                   'subject_portfolios.claim.notices.confirmed'
                 end
    flash[:success] = t(notice_key, member: @teaching_request.lead_instructor.full_name)

    respond_to do |format|
      format.html do
        redirect_to staff_manager_teaching_requests_path(
          sort: @teaching_request.status.text
        )
      end
      format.js
    end
  end

  def assignment_failed
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.js { render :update, status: :unprocessable_entity }
    end
  end

  def assignment_unavailable
    message = t('subject_portfolios.claim.errors.unavailable')
    @teaching_request.errors.add(:base, message)

    respond_to do |format|
      format.html do
        redirect_to staff_manager_teaching_requests_path, alert: message
      end
      format.js do
        flash[:alert] = message
        render :unavailable, status: :unprocessable_entity
      end
    end
  end
end
