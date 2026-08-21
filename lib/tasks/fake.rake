require 'json'
require 'date'
require 'csv'

module FakeData
  def self.subject_portfolios
    @subject_portfolios ||= [
      {
        name: 'Business',
        notification_email: 'business-portfolio@mailinator.com',
        member_emails: %w[milhouse@mailinator.com bart@mailinator.com]
      },
      {
        name: 'Health Sciences',
        notification_email: 'health-sciences-portfolio@mailinator.com',
        member_emails: %w[bart@mailinator.com lisa@mailinator.com]
      },
      {
        name: 'Humanities',
        notification_email: 'humanities-portfolio@mailinator.com',
        member_emails: %w[lisa@mailinator.com barney@mailinator.com]
      },
      {
        name: 'Social Sciences',
        notification_email: 'social-sciences-portfolio@mailinator.com',
        member_emails: %w[barney@mailinator.com milhouse@mailinator.com]
      }
    ].freeze
  end
end

namespace :fake do
  task ensure_development: :environment do
    abort 'Fake data tasks can only run in development.' unless Rails.env.development?
  end

  desc "Prepopulate Some Data"

  task factory_users: :ensure_development do
    require 'factory_bot'
    # FactoryBot.find_definitions
    include FactoryBot::Syntax::Methods

    # create(:valid_patron)
    # create(:prof_john_doe)
    create(:librarian_jane_doe)

    puts 'Fake users created successfully.'
  end



  desc "Create development users and dummy teaching requests"
  task generate: :ensure_development do
    Rake::Task["fake:ensure_courses"].invoke
    Rake::Task["fake:create_fake_users"].invoke
    Rake::Task["fake:create_subject_portfolios"].invoke
    Rake::Task["fake:create_dummy_requests"].invoke
    Rake::Task["fake:populate_tr_request_notes"].invoke
    Rake::Task["fake:repair_dummy_requests"].invoke
    Rake::Task["fake:create_dummy_portfolio_requests"].invoke
  end


  ##### FAKER TASKS #####

  desc "Ensure the bundled development course catalog is loaded"
  task ensure_courses: :ensure_development do
    data_file_path = ENV.fetch(
      'FAKE_COURSE_DATA_FILE',
      Rails.root.join('lib', 'assets', 'course-data', 'courses.csv').to_s
    )
    raise "Course data file not found at '#{data_file_path}'" unless File.exist?(data_file_path)

    expected_periods = CSV.foreach(data_file_path, headers: true).filter_map do |row|
      academic_year = row['ACADEMICYEAR']
      academic_term = row['STUDYSESSION']
      [academic_year, academic_term] if academic_year.present? && academic_term.present?
    end.uniq
    loaded_periods = InstituteCourse
                     .where(academic_year: expected_periods.map(&:first).uniq)
                     .distinct
                     .pluck(:academic_year, :academic_term)
    missing_periods = expected_periods - loaded_periods

    if missing_periods.empty?
      puts "Course catalog already contains #{expected_periods.size} bundled academic periods"
      next
    end

    puts "Loading missing course periods: #{missing_periods.map { |period| period.join(' ') }.join(', ')}"
    Rake::Task['courses:load_courses'].invoke(data_file_path)
    Rake::Task['courses:populate_missing_data'].invoke
  end

  desc "Create or repair development users and staff profiles"
  task create_fake_users: :ensure_development do
    require 'faker'
    require 'populator'

    User.create!(username: 'superadmin', first_name: 'Super', last_name: 'Admin', email: 'superadmin@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'superadmin@mailinator.com').first
    User.create!(username: 'pskinner', first_name: 'Principal', last_name: 'Skinner', email: 'skinner@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'skinner@mailinator.com').first
    User.create!(username: 'edna', first_name: 'Edna', last_name: 'Krabappel', email: 'Edna@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'db',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'edna@mailinator.com').first
    User.create!(username: 'mhouten', first_name: 'Milhouse', last_name: 'Van Houten', email: 'milhouse@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'milhouse@mailinator.com').first
    User.create!(username: 'bsimpson', first_name: 'Bart', last_name: 'Simpson', email: 'bart@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'bart@mailinator.com').first
    User.create!(username: 'lsimpson', first_name: 'Lisa', last_name: 'Simpson', email: 'lisa@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'lisa@mailinator.com').first
    User.create!(username: 'bgumble', first_name: 'Barney', last_name: 'Gumble', email: 'barney@mailinator.com', password: 'libstar', password_confirmation: 'libstar', user_source: 'fake',user_group: 'FACULTY::UNKNOWN',is_verified: true) if !User.where(email: 'barney@mailinator.com').first

      # user_record = User.where(email: 'superlibrarian@mailinator.com').first

    admin_user = User.find_by(email: 'superadmin@mailinator.com')
    manager_user = User.find_by(email: 'skinner@mailinator.com')
    librarian = User.where(email: 'milhouse@mailinator.com').first
    librarian_2 = User.where(email: 'bart@mailinator.com').first
    librarian_3 = User.where(email: 'lisa@mailinator.com').first
    librarian_4 = User.where(email: 'barney@mailinator.com').first
    instructor_users = [librarian, librarian_2, librarian_3, librarian_4].compact
    department = Department.order(:id).first
    raise 'Run db:seed before fake:create_fake_users to create departments.' unless department

    role_assignments = {
      admin_user => :administrator,
      manager_user => :manager
    }
    instructor_users.each { |user| role_assignments[user] = :staff_instructor }

    role_assignments.reject { |user, _role| user.nil? }.each do |user, role|
      staff_profile = StaffProfile.find_or_initialize_by(user: user)
      staff_profile.department ||= department
      staff_profile.role = role
      staff_profile.is_approved = true
      staff_profile.save!

      puts "Ensured staff profile for #{user.name} with role #{staff_profile.role}"
    end

    puts "User List"
    require 'terminal-table'
    data = User.includes(:staff_profile).where(id: StaffProfile.pluck(:user_id)).pluck(:id, :first_name, :last_name, :email, :role, :department_id, :user_group)
    table = Terminal::Table.new headings: ['ID', 'First Name', 'Last Name', 'Email', 'Role', 'Department ID', 'User Group'], rows: data
    puts table

  end

  desc "Create or repair development subject portfolios and memberships"
  task create_subject_portfolios: :ensure_development do
    FakeData.subject_portfolios.each do |attributes|
      name = attributes.fetch(:name)
      member_emails = attributes.fetch(:member_emails)
      portfolio = SubjectPortfolio.where('LOWER(name) = ?', name.downcase).first_or_initialize

      portfolio.assign_attributes(
        name: name,
        notification_email: attributes.fetch(:notification_email),
        active: true
      )
      portfolio.save!

      members_by_email = User
                         .where('LOWER(email) IN (?)', member_emails)
                         .index_by { |user| user.email.downcase }
      missing_emails = member_emails - members_by_email.keys

      if missing_emails.any?
        raise "Run fake:create_fake_users first. Missing portfolio members: #{missing_emails.join(', ')}"
      end

      member_emails.each do |email|
        portfolio.subject_portfolio_memberships.find_or_create_by!(user: members_by_email.fetch(email))
      end

      puts "Ensured #{portfolio.name} portfolio with #{portfolio.members.count} members"
    end
  end

  desc "Create dummy development teaching requests"
  task create_dummy_requests: :ensure_development do
    require 'faker'
    require 'populator'

    # enumerize :status, in: { not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, deleted: 9 }, default: :not_submitted
    # enumerize :duration, in: { thirty: "30", forty: "40", sixty: "60", sixty_plus: "60+" }
    # enumerize :location_preference, in: [:online, :pre_recorded, :in_the_class, :in_the_library, :off_campus, :to_be_determined], default: :to_be_determi

    course = InstituteCourse.find(InstituteCourse.pluck(:id).sample)
    # user = users.sample
    staff_users = User.where("id in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
    patron_users = User.where("id not in (SELECT sp.user_id from staff_profiles sp) AND email like '%mailinator.com'")
    locations = [:online, :pre_recorded, :in_the_class, :in_the_library, :off_campus, :to_be_determined]
    # durations = ["30", "40", "60", "60+"]
    durations = TeachingRequest.duration.values
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
      tr.academic_term = course.academic_term,
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
      tr.academic_term = course.academic_term,
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

      ## Step up record
      tr.username = Faker::Team.creature,
      tr.patron_type = '0',
      tr.first_name = patron.first_name,
      tr.last_name = patron.last_name,
      tr.email = patron.email,
      tr.phone = Faker::PhoneNumber.cell_phone,
      tr.academic_term = course.academic_term,
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

  desc "Repair missing required fields on existing dummy requests"
  task repair_dummy_requests: :ensure_development do
    dummy_user_ids = User.where('LOWER(email) LIKE ?', '%@mailinator.com').select(:id)
    repaired_count = TeachingRequest
                     .where(user_id: dummy_user_ids, academic_term: [nil, ''])
                     .update_all(academic_term: 'Missing', updated_at: Time.current)

    puts "Repaired academic terms on #{repaired_count} dummy teaching requests"
  end

  desc "Assign dummy requests to subject portfolio queues"
  task create_dummy_portfolio_requests: :ensure_development do
    portfolio_names = FakeData.subject_portfolios.map { |attributes| attributes.fetch(:name) }

    SubjectPortfolio.active.where(name: portfolio_names).order(:name).each do |portfolio|
      if portfolio.teaching_requests.awaiting_portfolio_lead.exists?
        puts "#{portfolio.name} already has a request awaiting a portfolio lead"
        next
      end

      request = TeachingRequest
                .where(
                  status: TeachingRequest.status.new_request.value,
                  subject_portfolio_id: nil,
                  lead_instructor_id: nil
                )
                .order(:id)
                .first

      unless request
        raise 'No unassigned new teaching request is available for the subject portfolio queue.'
      end

      request.update!(
        academic_term: request.academic_term.presence || 'Missing',
        subject_portfolio: portfolio,
        status: :in_process,
        course_title: "Portfolio queue demo: #{portfolio.name}"
      )

      puts "Assigned teaching request #{request.id} to the #{portfolio.name} portfolio queue"
    end
  end


  desc "Populate missing rich-text request notes in development"
  task :populate_tr_request_notes => :ensure_development do
    puts "Create Dummy Request Notes for All Teaching Requests"
    TeachingRequest.all.each do |request|
      # Skip the record if a rich text already exists
      next if ActionText::RichText.exists?(record_type: 'TeachingRequest', record_id: request.id, name: 'request_note')
  
      # Generate fake content for the request note
      fake_content = Faker::Lorem.paragraph
  
      # Create a new ActionText::RichText object and associate it with the teaching request
      rich_text = ActionText::RichText.create(record_type: 'TeachingRequest', record_id: request.id, name: 'request_note')
  
      # Set the content of the rich text to the fake content
      rich_text.body = fake_content
  
      # Save the rich text
      rich_text.save
    end
  end
  






end
