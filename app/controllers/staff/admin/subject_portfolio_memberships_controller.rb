class Staff::Admin::SubjectPortfolioMembershipsController < Staff::Admin::BaseController
  before_action :set_subject_portfolio

  def create
    membership = @subject_portfolio.subject_portfolio_memberships.new(membership_params)

    if membership.save
      redirect_to [:staff, :admin, @subject_portfolio],
                  notice: t('subject_portfolios.notices.member_added')
    else
      redirect_to [:staff, :admin, @subject_portfolio],
                  alert: membership.errors.full_messages.to_sentence
    end
  end

  def destroy
    membership = @subject_portfolio.subject_portfolio_memberships.find(params[:id])
    membership.destroy!

    redirect_to [:staff, :admin, @subject_portfolio],
                notice: t('subject_portfolios.notices.member_removed'),
                status: :see_other
  end

  private

  def set_subject_portfolio
    @subject_portfolio = SubjectPortfolio.find(params[:subject_portfolio_id])
  end

  def membership_params
    params.require(:subject_portfolio_membership).permit(:user_id)
  end
end
