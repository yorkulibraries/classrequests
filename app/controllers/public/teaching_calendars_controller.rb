class Public::TeachingCalendarsController < ApplicationController
  def index

    if params[:start_date] && params[:start_date] != nil
      start_param = params[:start_date]

      @today = start_param.to_date
      @start_date = @today.at_beginning_of_month
      @end_date = @start_date.next_month

      # @teachings = Section.where(preferred_date: @start_date..@end_date, status: Section.statuses[Section::IN_PROCESS]).order(:preferred_date, :preferred_time, :section_name_or_about)

      @teachings = TeachingRequest.where(preferred_date: @start_date..@end_date, status: [:in_process, :assigned]).order(:preferred_date, :preferred_time, :section_name_or_about)

      # @teachings = TeachingRequest.where(preferred_date: @start_date..@end_date, status: :in_process).order(:preferred_date, :preferred_time, :section_name_or_about)

      # @teachings = Section.where(preferred_date: @start_date..@end_date).order(:preferred_date, :preferred_time, :section_name_or_about)

    else
      @today = Date.today
      @start_date = @today.at_beginning_of_month
      @end_date = @start_date.next_month
      # @teachings = Section.all
      # @teachings = Section.where(preferred_date: @start_date..@end_date).order(:preferred_date, :preferred_time, :section_name_or_about)
      # @teachings = Section.where(preferred_date: @start_date..@end_date, status: Section.statuses[Section::IN_PROCESS]).order(:preferred_date, :preferred_time, :section_name_or_about)

      @teachings = TeachingRequest.where(preferred_date: @start_date..@end_date, status: [:in_process, :assigned]).order(:preferred_date, :preferred_time, :section_name_or_about)
    end
  end

end
