class Staff::DepartmentalReportsController < Staff::BaseController
  def index
    if current_user
      start_of_the_current_month = Date.today.at_beginning_of_month.strftime('%Y-%m-%d')
      end_of_the_current_month = (Date.today.at_beginning_of_month.next_month)
      start_of_the_previous_month = (Date.today.at_beginning_of_month - 1.month)
      year = Date.today.year
      start_of_the_year = Date.new(year,1,1)
      end_of_the_year = Date.new(year,12,31)
      @status_list_enum = TeachingRequest.status.options(except: [:not_submitted, :deleted])

      department = current_user.staff_profile.department_id 
      
      @status_list_enum = TeachingRequest.status.options(except: [:not_submitted, :deleted])
      @department_list = Department.all.pluck(:id, :name)
      
      @department_staff_members = StaffProfile.includes(:user).where(department_id: department)

      # @teachings = TeachingRequest.includes(:user, :staff_profile).where(staff_profile: { department_id: department }, status: [:assigned, :done])

      @teachings = TeachingRequest.where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done]))


      @teachings_last_month = TeachingRequest.where(preferred_date: "#{start_of_the_previous_month}".."#{start_of_the_current_month}").where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done])).count

      @teachings_this_month = TeachingRequest.where(preferred_date: "#{start_of_the_current_month}".."#{end_of_the_current_month}").where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done])).count

      @teachings_this_year = TeachingRequest.where(preferred_date: "#{start_of_the_year}".."#{end_of_the_year}",).where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done])).count

      @teachings_lifetime = TeachingRequest.where(lead_instructor: @department_staff_members, status: [:assigned, :done]).or(TeachingRequest.where(second_instructor: @department_staff_members, status: [:assigned, :done])).or(TeachingRequest.where(third_instructor: @department_staff_members, status: [:assigned, :done])).count

    end
  end
end
