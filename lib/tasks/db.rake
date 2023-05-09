require 'json'
require 'date'

namespace :db do


  task load_defaults: :environment do
    Rake::Task["db:load_default_departments"].invoke
    Rake::Task["db:load_default_type_of_instructions"].invoke
  end


  task load_default_departments: :environment do
    puts "Creating Default Departments"
    # location = Location.offset(rand(1..Location.count)).first


    # Teaching and Learning Division
    department = Department.find_or_initialize_by(name: "Student Learning & Academic Success", branch_division: "Teaching and Learning" ).save!
    department = Department.find_or_initialize_by(name: "Curriculum & Course Support", branch_division: "Teaching and Learning" ).save!
    department = Department.find_or_initialize_by(name: "Learning Commons & Reference Services", branch_division: "Teaching and Learning" ).save!

    # Research & Open Scholarship Division
    department = Department.find_or_initialize_by(name: "Content Development & Analysis", branch_division: "Research & Open Scholarship" ).save!
    department = Department.find_or_initialize_by(name: "Content Development & Acquisitions", branch_division: "Research & Open Scholarship" ).save!
    department = Department.find_or_initialize_by(name: "Open Scholarship", branch_division: "Research & Open Scholarship" ).save!
    department = Department.find_or_initialize_by(name: "Clara Thomas Archives & Special Collections", branch_division: "Research & Open Scholarship" ).save!

    # Digital Engagement & Strategy Division
    department = Department.find_or_initialize_by(name: "Digital Scholarship Infrastructure", branch_division: "Digital Engagement & Strategy" ).save!
    department = Department.find_or_initialize_by(name: "Metadata, Discovery and Access", branch_division: "Digital Engagement & Strategy" ).save!
    department = Department.find_or_initialize_by(name: "Library Digital Technology Services", branch_division: "Digital Engagement & Strategy" ).save!
    department = Department.find_or_initialize_by(name: "Library Digital Systems & Initiatives", branch_division: "Digital Engagement & Strategy" ).save!

    # Library Facilities
    department = Department.find_or_initialize_by(name: "Library Facilities", branch_division: "Library Facilities" ).save!

    # Librarian and Archivist Emeriti
    department = Department.find_or_initialize_by(name: "Librarian and Archivist Emeriti", branch_division: "Librarian and Archivist Emeriti" ).save!


    # location = Location.offset(rand(1..Location.count)).first
    department = Department.find_or_initialize_by(name: "Digital Scholarship Infrastructure", branch_division: "DSI" ).save!


    puts Department.all.count.ai

  end

  task load_default_type_of_instructions: :environment do 
    puts "Creating Types of Instruction"
    start_count = TypeOfInstruction.all.count 

    t_of_i = TypeOfInstruction.find_or_initialize_by(name: "Workshop / Co-curricular" ).save!
    t_of_i = TypeOfInstruction.find_or_initialize_by(name: "General Orientation" ).save!
    t_of_i = TypeOfInstruction.find_or_initialize_by(name: "Course Related" ).save!
    t_of_i = TypeOfInstruction.find_or_initialize_by(name: "Functional Instruction" ).save!
    t_of_i = TypeOfInstruction.find_or_initialize_by(name: "Guest Lecture" ).save!
    t_of_i = TypeOfInstruction.find_or_initialize_by(name: "Other" ).save!
    end_count = TypeOfInstruction.all.count 
    difference = end_count - start_count
    puts "Created: #{difference} Type of Instructions"
  end

  # t.string "email", default: "", null: false
  # t.string "encrypted_password", default: "", null: false
  # t.string "reset_password_token"
  # t.datetime "reset_password_sent_at"
  # t.datetime "remember_created_at"
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false
  # t.integer "sign_in_count", default: 0, null: false
  # t.datetime "current_sign_in_at"
  # t.datetime "last_sign_in_at"
  # t.string "current_sign_in_ip"
  # t.string "last_sign_in_ip"
  # t.string "user_uid"
  # t.string "username"
  # t.string "first_name"
  # t.string "last_name"
  # t.string "contact_phone"
  # t.string "alternate_email"
  # t.string "user_source", default: "db"
  # t.string "user_group", default: ""
  # t.string "iam_identification", default: "YorkU Instructor"
  # t.boolean "is_active", default: true
  # t.boolean "is_verified", default: false
  # t.datetime "announcements_last_read_at"
  # t.text "note"
  # t.index ["email"], name: "index_users_on_email", unique: true
  # t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  # t.index ["user_uid"], name: "index_users_on_user_uid"
  # t.index ["username"], name: "index_users_on_username"

  task create_production_users: :environment do

    user_record = User.where(email: 'admin@mailinator.com').first
    if !user_record
      user = User.new
      user.first_name = 'Admin'
      user.last_name = 'Doe'
      user.email = 'admin@mailinator.com'
      user.password = 'ADMIN!@#$'
      user.password_confirmation = 'ADMIN!@#$'
      user.user_source = 'db'
      user.user_group = 'STAFF'
      user.is_verified = true
      user.save!

      puts "Created user #{user.first_name} #{user.last_name}"
    else
      puts "User #{user_record.name} already exists, skipping"
    end
  end

  ### STAFF PROFILES!
  task create_production_profiles: :environment do
    user_record = User.where(email: 'admin@mailinator.com').first
    # puts user_record.ai

    if user_record
      staff_profile_check = StaffProfile.where(user_id: user_record.id).first
      puts staff_profile_check.ai
      if !staff_profile_check
        staff_role = StaffProfile.new
        staff_role.user = user_record
        staff_role.department = Department.first #note-to-self,create departments first
        staff_role.role = 4
        staff_role.is_approved = true
        staff_role.save!
        puts "Added staff profile for #{user_record.name} with role #{staff_role.role}"
      end
    else
      puts "Unable to find user"
    end
  end

end
