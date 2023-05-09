class Staff::Admin::TypeOfInstructionsController < Staff::Admin::BaseController
  before_action :set_type_of_instruction, only: %i[ show edit update destroy ]

  # GET /type_of_instructions or /type_of_instructions.json
  def index
    @type_of_instructions = TypeOfInstruction.all
  end

  # GET /type_of_instructions/1 or /type_of_instructions/1.json
  def show
  end

  # GET /type_of_instructions/new
  def new
    @type_of_instruction = TypeOfInstruction.new
  end

  # GET /type_of_instructions/1/edit
  def edit
  end

  # POST /type_of_instructions or /type_of_instructions.json
  def create
    @type_of_instruction = TypeOfInstruction.new(type_of_instruction_params)

    respond_to do |format|
      if @type_of_instruction.save
        format.html { redirect_to staff_admin_type_of_instructions_url, notice: "Type of instruction was successfully created." }
        format.json { render :show, status: :created, location: @type_of_instruction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @type_of_instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_of_instructions/1 or /type_of_instructions/1.json
  def update
    respond_to do |format|
      if @type_of_instruction.update(type_of_instruction_params)
        format.html { redirect_to [:staff, :admin, @type_of_instruction], notice: "Type of instruction was successfully updated." }
        format.json { render :show, status: :ok, location: @type_of_instruction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @type_of_instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_of_instructions/1 or /type_of_instructions/1.json
  def destroy
    @type_of_instruction.destroy
    respond_to do |format|
      format.html { redirect_to type_of_instructions_url, notice: "Type of instruction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_of_instruction
      @type_of_instruction = TypeOfInstruction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def type_of_instruction_params
      params.require(:type_of_instruction).permit(:name)
    end
end
