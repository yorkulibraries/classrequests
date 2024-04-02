class Staff::Manager::ReportsController < Staff::Manager::BaseController
  def index
    if current_user
      start_of_the_current_month = Date.today.at_beginning_of_month.strftime('%Y-%m-%d')
      end_of_the_current_month = (Date.today.at_beginning_of_month.next_month)
      start_of_the_previous_month = (Date.today.at_beginning_of_month - 1.month)
      year = Date.today.year
      start_of_the_year = Date.new(year,1,1)
      end_of_the_year = Date.new(year,12,31)

      @status_list_enum = TeachingRequest.status.options(except: [:not_submitted])

      @teachings_last_month = TeachingRequest.where(preferred_date: "#{start_of_the_previous_month}".."#{start_of_the_current_month}", status: [:assigned, :done]).count

      @teachings_this_month = TeachingRequest.where(preferred_date: "#{start_of_the_current_month}".."#{end_of_the_current_month}", status: [:assigned, :done]).count

      @teachings_this_year = TeachingRequest.where(preferred_date: "#{start_of_the_year}".."#{end_of_the_year}", status: [:assigned, :done]).count

      @counts_by_faculty = TeachingRequest.select('faculty, faculty_abbrev, COUNT(*) as teachings').group('faculty, faculty_abbrev').order('teachings DESC')

      @counts_by_location = TeachingRequest.select('faculty, faculty_abbrev, location_preference, COUNT(*) as teachings').group('faculty, faculty_abbrev, location_preference').order('location_preference ASC, teachings DESC, faculty ASC')

      @counts_by_duration = TeachingRequest.select('faculty, faculty_abbrev, duration, COUNT(*) as teachings').group('faculty, faculty_abbrev, duration').order('duration ASC, teachings DESC, faculty ASC')

    end
  end
end
