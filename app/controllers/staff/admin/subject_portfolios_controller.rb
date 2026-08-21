class Staff::Admin::SubjectPortfoliosController < Staff::Admin::BaseController
  before_action :set_subject_portfolio, only: %i[show edit update destroy]

  def index
    @subject_portfolios = SubjectPortfolio
      .left_joins(:subject_portfolio_memberships)
      .group(:id)
      .select('subject_portfolios.*, COUNT(subject_portfolio_memberships.id) AS memberships_count')
      .order(:name)
  end

  def show
    load_membership_options
  end

  def new
    @subject_portfolio = SubjectPortfolio.new
  end

  def create
    @subject_portfolio = SubjectPortfolio.new(subject_portfolio_params)

    if @subject_portfolio.save
      redirect_to [:staff, :admin, @subject_portfolio],
                  notice: t('subject_portfolios.notices.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subject_portfolio.update(subject_portfolio_params)
      redirect_to [:staff, :admin, @subject_portfolio],
                  notice: t('subject_portfolios.notices.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @subject_portfolio.destroy
      redirect_to staff_admin_subject_portfolios_path,
                  notice: t('subject_portfolios.notices.destroyed'),
                  status: :see_other
    else
      redirect_to [:staff, :admin, @subject_portfolio],
                  alert: t('subject_portfolios.notices.in_use'),
                  status: :see_other
    end
  end

  private

  def set_subject_portfolio
    @subject_portfolio = SubjectPortfolio.find(params[:id])
  end

  def load_membership_options
    @subject_portfolio_memberships = @subject_portfolio
      .subject_portfolio_memberships
      .includes(user: { staff_profile: :department })
      .joins(:user)
      .order('users.last_name', 'users.first_name', 'users.email')
    @subject_portfolio_membership = @subject_portfolio.subject_portfolio_memberships.new
    @eligible_members = User
      .eligible_for_subject_portfolios
      .where.not(id: @subject_portfolio.member_ids)
      .includes(staff_profile: :department)
      .order(:last_name, :first_name, :email)
  end

  def subject_portfolio_params
    params.require(:subject_portfolio).permit(:name, :notification_email, :active)
  end
end
