require 'json'
require 'date'

namespace :fake do
  desc "Prepopulate Some Data"

  task generate: :environment do
    Rake::Task["fake:create_fake_users"].invoke
    Rake::Task["fake:create_dummy_requests"].invoke
  end


  ##### FAKER TASKS #####

  task create_fake_users: :environment do
    require 'faker'
    require 'populator'

    admin = User.find_or_create_by!(username: 'superadmin', first_name: 'Super', last_name: 'Admin', email: 'superadmin@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'superadmin@mailinator.com').first
    manager = User.find_or_create_by!(username: 'pskinner', first_name: 'Principal', last_name: 'Skinner', email: 'skinner@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'skinner@mailinator.com').first
    faculty = User.find_or_create_by!(username: 'edna', first_name: 'Edna', last_name: 'Krabappel', email: 'Edna@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'db',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'edna@mailinator.com').first
    librarian = User.find_or_create_by!(username: 'mhouten', first_name: 'Milhouse', last_name: 'Van Houten', email: 'milhouse@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'milhouse@mailinator.com').first
    librarian_2 = User.find_or_create_by!(username: 'bsimpson', first_name: 'Bart', last_name: 'Simpson', email: 'bart@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'bart@mailinator.com').first
    librarian_3 = User.find_or_create_by!(username: 'lsimpson', first_name: 'Lisa', last_name: 'Simpson', email: 'lisa@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'lisa@mailinator.com').first
    librarian_4 = User.find_or_create_by!(username: 'bgumble', first_name: 'Barney', last_name: 'Gumble', email: 'barney@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'barney@mailinator.com').first

      # user_record = User.where(email: 'superlibrarian@mailinator.com').first

    admin_users = [User.where(email: 'superadmin@mailinator.com').first]
    manager_users = [User.where(email: 'skinner@mailinator.com').first]
    librarian = User.where(email: 'milhouse@mailinator.com').first
    librarian_2 = User.where(email: 'bart@mailinator.com').first
    librarian_3 = User.where(email: 'lisa@mailinator.com').first
    librarian_4 = User.where(email: 'barney@mailinator.com').first
    instructor_users = [librarian, librarian_2, librarian_3, librarian_4]
    department = Department.find(Department.pluck(:id).sample)

    instructor_users.each do |u|
      if u != nil
        staff_profile_check = StaffProfile.where(user_id: u.id).first
        puts staff_profile_check.ai
        if !staff_profile_check
          staff_role = StaffProfile.new
          staff_role.user = u
          staff_role.department = department #note-to-self,create departments first
          staff_role.role = '2'
          staff_role.is_approved = true
          staff_role.save!
          puts "Added staff profile for #{u.name} with role #{staff_role.role}"
        end
      end
    end
    admin_users.each do |u|
      if u != nil
        staff_profile_check = StaffProfile.where(user_id: u.id).first
        puts staff_profile_check.ai
        if !staff_profile_check
          staff_role = StaffProfile.new
          staff_role.user = u
          staff_role.department = department #note-to-self,create departments first
          staff_role.role = '4'
          staff_role.is_approved = true
          staff_role.save!
          puts "Added staff profile for #{u.name} with role #{staff_role.role}"
        end
      end
    end
    manager_users.each do |u|
      if u != nil
        staff_profile_check = StaffProfile.where(user_id: u.id).first
        puts staff_profile_check.ai
        if !staff_profile_check
          staff_role = StaffProfile.new
          staff_role.user = u
          staff_role.department = department #note-to-self,create departments first
          staff_role.role = '3'
          staff_role.is_approved = true
          staff_role.save!
          puts "Added staff profile for #{u.name} with role #{staff_role.role}"
        end
      end
    end
  end

  task create_dummy_requests: :environment do
    require 'faker'
    require 'populator'

    users = User.where("email like ?", '%@mailinator.com')

    # enumerize :status, in: { not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, deleted: 9 }, default: :not_submitted
    # enumerize :duration, in: { thirty: "30", forty: "40", sixty: "60", sixty_plus: "60+" }
    # enumerize :location_preference, in: [:online, :pre_recorded, :in_the_class, :in_the_library, :off_campus, :to_be_determined], default: :to_be_determi

    email_list = ["superadmin@mailinator.com", "skinner@mailinator.com", "Edna@mailinator.com", "milhouse@mailinator.com", "bart@mailinator.com", "lisa@mailinator.com", 'barney@mailinator.com' ]

    course = InstituteCourse.find(InstituteCourse.pluck(:id).sample)
    # user = users.sample
    staff_users = User.where("id in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
    patron_users = User.where("id not in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
    locations = [:online, :pre_recorded, :in_the_class, :in_the_library, :off_campus, :to_be_determined]
    durations = ["30", "40", "60", "60+"]
    status_not_new = ['2', '3', '4', '6']
    status_assigned_in_process_only = ['2', '3']

    # puts course.ai
    # puts user.ai
    # puts patron.ai
    # puts locations.sample
    # preferred_date_parsed = Date.today+rand(10000)
    # puts preferred_date_parsed
    # puts preferred_time_parsed
    # puts alternate_date_parsed

    TeachingRequest.populate(10) do |tr|

      ## Step Constants
      course = InstituteCourse.find(InstituteCourse.pluck(:id).sample)
      staff = staff_users.sample
      patron_users = User.where("id not in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
      patron = patron_users.sample
      preferred_date_parsed = Faker::Date.between(from: Date.today, to: Date.today + 90) #=> #<Date: 2014-09-24>
      preferred_time_parsed = DateTime.parse(Faker::Time.between_dates(from: preferred_date_parsed, to: preferred_date_parsed + 5, format: :default)).strftime('%I:%M:%S')
      alternate_date_parsed = Faker::Date.between(from: Date.today, to: Date.today + 90) #=> #<Date: 2014-09-24>
      alternate_time_parsed = DateTime.parse(Faker::Time.between_dates(from: alternate_date_parsed, to: alternate_date_parsed + 5, format: :default)).strftime('%I:%M:%S')

      # Faker::Config.locale = 'en-CA'

      ## Step up record

      tr.username = Faker::Team.creature,
      tr.patron_type = '0',
      tr.first_name = patron.first_name,
      tr.last_name = patron.last_name,
      tr.email = patron.email,
      tr.phone = Faker::PhoneNumber.cell_phone,
      tr.academic_year = course.academic_year,
      tr.faculty = course.faculty,
      tr.faculty_abbrev = course.faculty_abbrev,
      tr.subject = course.subject,
      tr.subject_abbrev = course.subject_abbrev,
      tr.course_title = Faker::Book.unique.title,
      tr.course_number = course.number,
      tr.submitted_by = patron.name,
      tr.submitted_on_behalf = '',
      tr.section_name_or_about = Faker::Lorem.characters(number: 3, min_alpha: 1, min_numeric: 2),
      tr.number_of_students = Faker::Number.number(digits: 2),
      tr.preferred_date = preferred_date_parsed,
      tr.preferred_time = preferred_time_parsed,
      tr.alternate_date = alternate_date_parsed,
      tr.alternate_time = alternate_time_parsed,
      tr.duration = durations.sample,
      tr.location_preference = locations.sample,
      # tr.lead_instructor_id = '',
      # tr.second_instructor_id = '',
      # tr.third_instructor_id = '',
      tr.room = Faker::TvShows::Simpsons.location,
      tr.status = '1',
      tr.request_note = Faker::Lorem.paragraph,
      tr.instructor_notes = '',
      tr.user_id = patron.id,
      tr.created_at = DateTime.now(),
      tr.updated_at = DateTime.now()

      puts tr.ai
    end

    ## ASSIGNED AND INPROCESS LEAD REQUESTS
    TeachingRequest.populate(10) do |tr|

      ## Step Constants
      course = InstituteCourse.find(InstituteCourse.pluck(:id).sample)
      staff = staff_users.sample
      patron_users = User.where("id not in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
      patron = patron_users.sample
      preferred_date_parsed = Faker::Date.between(from: Date.today, to: Date.today + 90) #=> #<Date: 2014-09-24>
      preferred_time_parsed = DateTime.parse(Faker::Time.between_dates(from: preferred_date_parsed, to: preferred_date_parsed + 5, format: :default)).strftime('%I:%M:%S')
      alternate_date_parsed = Faker::Date.between(from: Date.today, to: Date.today + 90) #=> #<Date: 2014-09-24>
      alternate_time_parsed = DateTime.parse(Faker::Time.between_dates(from: alternate_date_parsed, to: alternate_date_parsed + 5, format: :default)).strftime('%I:%M:%S')
      status_id = status_assigned_in_process_only.sample
      # status_not_new.sample

      # Faker::Config.locale = 'en-CA'

      ## Step up record

      tr.username = Faker::Team.creature,
      tr.patron_type = '0',
      tr.first_name = patron.first_name,
      tr.last_name = patron.last_name,
      tr.email = patron.email,
      tr.phone = Faker::PhoneNumber.cell_phone,
      tr.academic_year = course.academic_year,
      tr.faculty = course.faculty,
      tr.faculty_abbrev = course.faculty_abbrev,
      tr.subject = course.subject,
      tr.subject_abbrev = course.subject_abbrev,
      tr.course_title = Faker::Book.unique.title,
      tr.course_number = course.number,
      tr.submitted_by = patron.name,
      tr.submitted_on_behalf = '',
      tr.section_name_or_about = Faker::Lorem.characters(number: 3, min_alpha: 1, min_numeric: 2),
      tr.number_of_students = Faker::Number.number(digits: 2),
      tr.preferred_date = preferred_date_parsed,
      tr.preferred_time = preferred_time_parsed,
      tr.alternate_date = alternate_date_parsed,
      tr.alternate_time = alternate_time_parsed,
      tr.duration = durations.sample,
      tr.location_preference = locations.sample,
      tr.lead_instructor_id = staff.id,
      # tr.second_instructor_id = '',
      # tr.third_instructor_id = '',
      tr.room = Faker::TvShows::Simpsons.location,
      tr.status = status_id,
      tr.request_note = Faker::Lorem.paragraph,
      tr.instructor_notes = '',
      tr.user_id = patron.id,
      tr.created_at = DateTime.now(),
      tr.updated_at = DateTime.now()
    end

    ## REQUESTS NOT NEW
    TeachingRequest.populate(20) do |tr|

      ## Step Constants
      course = InstituteCourse.find(InstituteCourse.pluck(:id).sample)
      staff = staff_users.sample
      patron_users = User.where("id not in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
      patron = patron_users.sample
      preferred_date_parsed = Faker::Date.between(from: Date.today, to: Date.today + 90) #=> #<Date: 2014-09-24>
      preferred_time_parsed = DateTime.parse(Faker::Time.between_dates(from: preferred_date_parsed, to: preferred_date_parsed + 5, format: :default)).strftime('%I:%M:%S')
      alternate_date_parsed = Faker::Date.between(from: Date.today, to: Date.today + 90) #=> #<Date: 2014-09-24>
      alternate_time_parsed = DateTime.parse(Faker::Time.between_dates(from: alternate_date_parsed, to: alternate_date_parsed + 5, format: :default)).strftime('%I:%M:%S')
      status_id = status_not_new.sample
      # status_not_new.sample

      # Faker::Config.locale = 'en-CA'

      ## Step up record
      tr.username = Faker::Team.creature,
      tr.patron_type = '0',
      tr.first_name = patron.first_name,
      tr.last_name = patron.last_name,
      tr.email = patron.email,
      tr.phone = Faker::PhoneNumber.cell_phone,
      tr.academic_year = course.academic_year,
      tr.faculty = course.faculty,
      tr.faculty_abbrev = course.faculty_abbrev,
      tr.subject = course.subject,
      tr.subject_abbrev = course.subject_abbrev,
      tr.course_title = Faker::Book.unique.title,
      tr.course_number = course.number,
      tr.submitted_by = patron.name,
      tr.submitted_on_behalf = '',
      tr.section_name_or_about = Faker::Lorem.characters(number: 3, min_alpha: 1, min_numeric: 2),
      tr.number_of_students = Faker::Number.number(digits: 2),
      tr.preferred_date = preferred_date_parsed,
      tr.preferred_time = preferred_time_parsed,
      tr.alternate_date = alternate_date_parsed,
      tr.alternate_time = alternate_time_parsed,
      tr.duration = durations.sample,
      tr.location_preference = locations.sample,
      tr.lead_instructor_id = staff.id,
      tr.second_instructor_id = staff_users.sample.id,
      # tr.third_instructor_id = '',
      tr.room = Faker::TvShows::Simpsons.location,
      tr.status = status_id,
      tr.request_note = Faker::Lorem.paragraph,
      tr.instructor_notes = '',
      tr.user_id = patron.id,
      tr.created_at = DateTime.now(),
      tr.updated_at = DateTime.now()


    end
    puts "Create Dummy Teaching Requests"

  end






end
