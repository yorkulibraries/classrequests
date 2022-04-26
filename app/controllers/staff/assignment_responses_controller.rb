class Staff::AssignmentResponsesController < Staff::BaseController
  before_action :set_assignment_response, only: %i[ show edit update destroy ]
  before_action :load_teaching_request
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
    # @assignment_response = @teaching_request.assignment_responses.new(assignment_response_params)
    @assignment_response = AssignmentResponse.new(assignment_response_params)

    lead_name = @assignment_response.teaching_request.lead_instructor.name
    lead_email = @assignment_response.teaching_request.lead_instructor.email

    if @assignment_response.response == AssignmentResponse.response.accept
      @assignment_response.teaching_request.status = TeachingRequest.status.assigned

    elsif @assignment_response.response == AssignmentResponse.response.decline
      @assignment_response.teaching_request.status = TeachingRequest.status.new_request
      @assignment_response.teaching_request.lead_instructor = nil
    end

    respond_to do |format|
      if @assignment_response.save

        ## SEND ASSIGNED LEAD INSTRUCTOR EMAIL
        if @assignment_response.comment_or_reason
          message = @assignment_response.comment_or_reason
        else
          message = 'No comment / reason given'
        end

        tr = @assignment_response.teaching_request
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

    def set_teaching_request_status

    end
    # Only allow a list of trusted parameters through.
    def assignment_response_params
      params.require(:assignment_response).permit(:response, :comment_or_reason, :teaching_request_id, :user_id, teaching_request_attributes: [:id, :status, :lead_instructor, :second_instructor_id, :third_instructor_id] )
    end

end
