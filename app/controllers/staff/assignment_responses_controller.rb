class Staff::AssignmentResponsesController < Staff::BaseController
  before_action :set_assignment_response, only: %i[ show edit update destroy ]
  before_action :load_teaching_request
  before_action :authorize_current_lead, only: %i[new create]
  # before_save :set_teaching_request_status

  # GET /assignment_responses or /assignment_responses.json
  def index
    @assignment_responses = @teaching_request.assignment_responses
  end

  # GET /assignment_responses/1 or /assignment_responses/1.json
  def show
  end

  # GET /assignment_responses/new
  def new
    @assignment_response = AssignmentResponse.new
    # puts AssignmentResponse.teaching_request.build(assignment_response_params).ai
    # @assignment_response = AssignmentResponse.teaching_request.build(assignment_response_params)

  end

  # GET /assignment_responses/1/edit
  def edit
  end

  # POST /assignment_responses or /assignment_responses.json
  def create
    @assignment_response = @teaching_request.assignment_responses.new(
      assignment_response_params.merge(user: current_user)
    )

    lead_name = @teaching_request.lead_instructor.name
    lead_email = @teaching_request.lead_instructor.email

    respond_to do |format|
      if @teaching_request.record_lead_assignment_response(@assignment_response)

        ## SEND ASSIGNED LEAD INSTRUCTOR EMAIL
        message = @assignment_response.comment_or_reason.presence || 'No comment / reason given'

        tr = @teaching_request
        StaffMailer.lead_assignment_response(tr, @assignment_response.response.text, message, lead_name, lead_email).deliver_now

        if tr.status.assigned?
          RequestorMailer.request_assignment(@assignment_response.teaching_request).deliver_now
        end

        # format.html { redirect_to @assignment_response, notice: 'Assignment response was successfully created.' }
        format.html { redirect_to staff_dashboard_path(sort: @teaching_request.status.text), success: 'Request status was successfully updated.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment_response.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PATCH/PUT /assignment_responses/1 or /assignment_responses/1.json
  def update
    respond_to do |format|
      if @assignment_response.update(assignment_response_params)
        # format.html { redirect_to @assignment_response, notice: 'Assignment response was successfully updated.' }
        format.html { redirect_to staff_dashboard_path(sort: @teaching_request.status.text), success: 'Request status was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment_response }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_responses/1 or /assignment_responses/1.json
  def destroy
    @assignment_response.destroy
    respond_to do |format|
      format.html { redirect_to assignment_responses_url, notice: 'Assignment response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_teaching_request
      @teaching_request = TeachingRequest.find(params[:teaching_request_id])
    end

    def set_assignment_response
      @assignment_response = AssignmentResponse.find(params[:id])
    end

    def authorize_current_lead
      return if @teaching_request.status&.in_process? &&
                @teaching_request.lead_instructor_id == current_user.id

      render file: Rails.root.join('public/403.html').to_s, status: :forbidden, layout: false
    end

    def set_teaching_request_status

    end
    # Only allow a list of trusted parameters through.
    def assignment_response_params
      params.require(:assignment_response).permit(:response, :comment_or_reason)
    end

end
