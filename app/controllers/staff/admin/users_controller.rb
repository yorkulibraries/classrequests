class Staff::Admin::UsersController < Staff::Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  # def new
  #   @user = User.new
  # end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)
  #
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to staff_admin_users_url, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)

      else
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        puts 'HASH = ' + hashed
        @user.reset_password_token = hashed
        @user.reset_password_sent_at = Time.now.utc
        @user.save
      end

      if @user.update(user_params)
        format.html { redirect_to staff_admin_users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy!
    respond_to do |format|
      format.html { redirect_to staff_admin_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(
      :id, :email,
      :encrypted_password,
      :reset_password_token,
      :reset_password_sent_at,
      :remember_created_at,
      :created_at,
      :updated_at,
      :sign_in_count,
      :current_sign_in_at,
      :last_sign_in_at,
      :current_sign_in_ip,
      :last_sign_in_ip,
      :user_uid,
      :username,
      :first_name,
      :last_name,
      :contact_phone,
      :alternate_email,
      :user_source,
      :user_group,
      :iam_identification,
      :is_active,
      :is_verified,
      :announcements_last_read_at,
      :note, :password, :password_confirmation,
      staff_profile_attributes: [:specializtion_job_title, :profile_bio, :role, :department_id, :user_id, :is_approved])
  end
end
