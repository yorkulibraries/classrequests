class Public::TeachingCalendarsController < ApplicationController
  def index

    if params[:start_date] && params[:start_date] != nil
      start_param = params[:start_date]

      @today = start_param.to_date
      @start_date = @today.at_beginning_of_month
      @end_date = @start_date.next_month

      @teachings = TeachingRequest.where(preferred_date: @start_date..@end_date, status: [:in_process, :assigned, :done]).order(:preferred_date, :preferred_time, :section_name_or_about)

    else
      @today = Date.today
      @start_date = @today.beginning_of_year
      @end_date = @start_date.end_of_year

      @teachings = TeachingRequest.where(preferred_date: @start_date..@end_date, status: [:in_process, :assigned, :done]).order(:preferred_date, :preferred_time, :section_name_or_about)
    end
  end

end
