require 'json'
require 'date'

namespace :db do


  task load_defaults: :environment do
    Rake::Task["db:load_default_departments"].invoke
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

    user_record = User.where(email: 'jdoe1234@yorku.ca').first
    if !user_record
      user = User.new
      user.first_name = 'John'
      user.last_name = 'Doe'
      user.email = 'jdoe1234@yorku.ca'
      user.password = 'JOHND!@#$'
      user.password_confirmation = 'JOHND!@#$'
      user.user_source = 'ppy'
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
    user_record = User.where(email: 'jdoe1234@yorku.ca').first
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

  ## LOAD OLD Data
  task old_existing_teaching_data: :environment do
    require 'date'

    linecounter = 0; no_of_records_found = 0;
    no_of_records_updated = 0; skipped = 0;

    ## Read the export csv
    data_file = File.join(Rails.root, 'lib', 'assets', 'classrequests_data_feb25-headers-withoutnote.csv')

    ## Loop each line
    CSV.foreach(data_file, headers: false) do |row|
      linecounter = linecounter + 1
      if row[16] == nil
        preferred_date = ''
      else
        preferred_date_parsed = Date.strptime(row[16], "%Y-%m-%d")
      end
      if row[18] == nil
        alternate_date = ''
      else
        alternate_date_parsed = Date.strptime(row[18], "%Y-%m-%d")
      end
      if row[26] == nil
        created_at = ''
      else
        created_at_parsed = row[26].to_datetime
      end
      if row[27] == nil
        updated_at = ''
      else
        updated_at_parsed = row[27].to_datetime
      end


      if row[17] == nil || row[17] == ''
        preferred_time_parsed = ''
      else
        preferred_time_parsed = Time.parse(row[17])
      end
      if row[18] == nil || row[18] == ''
        alternate_time_parsed = ''
      else
        alternate_time_parsed = Time.parse(row[18])
      end

      # Location Preference Fix
      # enumerize :location_preference, in: [:online, :pre_recorded, :in_the_class, :in_the_library, :tbd], default: :tbd
      row[20] = row[20].strip rescue nil
      row[21] = row[21].strip rescue nil

      if row[21] == "" || row[21] == nil
        location_parsed == "to_be_determined"
      elsif row[21] == "TBD" || row[21] == "room to be determined"
        location_parsed = "to_be_determined"
      elsif row[21].match(/online(\S*) (.*)/) || row[21].match(/(.*)(online|zoom|asynchronous)(.*)/i)
        location_parsed = "online"
      elsif row[21] == "Steacie 012" || row[21] == "LAS C" || row[21] == "Frost" || row[21] == "Scott 530" ||
            row[21].match(/(LAS|Library|library|Glendon|Scott|Steacie|Bronfman|Frost|SMIL)(\S*) (.*)/) ||
            row[21] == "Scott 530 or 531" || row[21].match(/(Library|530|531|Scott|Steacie|Bronfman|Frost|SMIL)(.*)/i)

        location_parsed = "in_the_library"

      elsif row[21] == "CLHB" || row[21] == "CLH-F" || row[21] == "CLH-A" || row[21] == "HNES" || row[21] == "DB 0014" ||
            row[21] == "ACE 002" || row[21] == "ACE004/CLHJ" ||
            row[21].match(/(HNES|CLH|Ross|DH|DB|classroom|CC|VH|R|CB|ACW|Stedman|Curtis|SLH|Vari|York|S|Kaneff|ACE|Dahdaleh|N143|ATK|FC|MC|Lab|YH)(\S*) (.*)/) ||
            row[21].match(/(DB-|DH-|CLH-|DB|Nowhere!|Classroom|RS110|N106|W257|N108|N107|N106|N105|N109|N110|N111|S128|HNE031|BRG217|Lab|YH|W136|Xuemei's|S|R|W|N|ACE|ATK|FC|MC|ACW|CHL|BC|CC|VH|CB|DB|DH|CLH|1)(.*)/i)
        location_parsed = "in_the_class"

      elsif row[21].match(/off(\S*) (.*)/)
        location_parsed = "off_campus"

      elsif row[21].match(/video(.*)/i)
        location_parsed = "pre_recorded"
      end

      ## Duration Fix
      # enumerize :duration, in: { thirty: "30", forty: "40", sixty: "60", sixty_plus: "60+" }
      if row[20] == "" || row[20] == " " || row[20] == nil
        row[20] = "30"
      elsif row[20].match(/(30|15|20|25)(\S*) (.*)/) || row[20].match(/(30|15|20|25|asynchronous|synchronous|Asychronous)(.*)/i) || row[20].match(/(to)(\S*) (.*)/)
        row[20] = "30"
      elsif row[20] == "60ish minutes" || row[20] == "60 MINUTES" || row[20] == "50 mins" || row[20] == "50" ||
            row[20].match(/(40|45|50|1)(\S*) (.*)/) || row[20] == "30-45" ||
            row[20].match(/(45|50|55|35|1 hr|1|one)(.*)/) ||
            row[20] == "1hr" ||
            row[20].match(/(.*)hour(.*)/)

        row[20] = "60"
      elsif row[20] == "75" || row[20] == "90" || row[20] == "180" || row[20] == "2 hours" ||
            row[20].match(/(2|3|60|75|80|90|120|1 hour|6o|1hr|2hr)(\S*) (.*)/) ||
            row[20].match(/(60|90|120|1.5|80|85|95|100|75|2|3|3.5|2.5)(.*)/)

        row[20] = "60+"
      end
      #puts "After::::: #{row[2]} : #{row[4]} : #{preferred_date_parsed} : #{alternate_date_parsed} : #{created_at_parsed} : #{updated_at_parsed}"

      # mysql_time = "37800".to_time
      # puts mysql_time
      # mysql_time2 = "10:30:00".to_time
      # puts mysql_time2
      # puts "======================"

      # if linecounter == 5
      #   exit
      # end
      # puts "#{row}"

      puts "\n username: #{row[0]},
      patron_type: #{row[1]},
      first_name: #{row[2]},
      last_name: #{row[3]},
      email: #{row[4]},
      phone: #{row[5]},
      academic_year: #{row[6]},
      faculty: #{row[7]},
      faculty_abbrev: #{row[8]} ,
      subject: #{row[9]},
      subject_abbrev:#{row[10]} ,
      course_title: #{row[11]},
      course_number: #{row[12]},
      submitted_by: #{row[13]},
      submitted_on_behalf: '',
      section_name_or_about: #{row[14]},
      number_of_students: #{row[15]},
      preferred_date: #{preferred_date_parsed},
      preferred_time: #{row[17]},
      preferred_time_parsed - #{preferred_time_parsed},
      alternate_date: #{row[18]},
      alternate_time: #{row[19]},
      duration: #{row[20]},
      location_preference: #{location_parsed},
      lead_instructor_id: #{row[22]},
      second_instructor_id: #{row[23]},
      third_instructor_id: #{row[24]},
      status: #{row[25]},
      request_note: 'old-data-notes-not-copied',
      instructor_notes: '',
      user_id: 0,
      created_at: #{created_at_parsed},
      updated_at: #{updated_at_parsed}"

      puts linecounter;


      new_teaching_request = TeachingRequest.create!(
        username: row[0],
        patron_type: row[1],
        first_name: row[2],
        last_name: row[3],
        email: row[4],
        phone: row[5],
        academic_year: row[6],
        faculty: row[7],
        faculty_abbrev: row[8] ,
        subject: row[9],
        subject_abbrev:row[10] ,
        course_title: row[11],
        course_number: row[12],
        submitted_by: row[13],
        submitted_on_behalf: '',
        section_name_or_about: row[14],
        number_of_students: row[15],
        preferred_date: preferred_date_parsed,
        preferred_time: preferred_time_parsed,
        alternate_date: alternate_date_parsed,
        alternate_time: alternate_time_parsed,
        duration: row[20],
        location_preference: location_parsed,
        room: row[21],
        lead_instructor_id: row[22],
        second_instructor_id: row[23],
        third_instructor_id: row[24],
        status: row[25],
        request_note: 'old-data-notes-not-copied',
        instructor_notes: '',
        user_id: 0,
        created_at: created_at_parsed,
        updated_at: updated_at_parsed)

        # new_teaching_request.save

      end # CSV Loop

        puts "#{linecounter} records added"
  end

  task old_existing_user_data: :environment do
    linecounter = 0; no_of_records_found = 0;
    no_of_records_updated = 0; skipped = 0;

    ## Read the export csv
    data_file = File.join(Rails.root, 'lib', 'assets', 'classrequests_data_feb25-users.csv')

    ## Loop each line
    # "ID","Username","Email","First Name","Last Name","Is Active","Created","Updated"
    CSV.foreach(data_file, headers: false) do |row|
      linecounter = linecounter + 1
      puts "User #{row[0]}::#{row[1]}::#{row[2]}::#{row[3]}::#{row[4]}::#{row[5]}::#{row[6]}::"

      next if linecounter == 1

      if row[6] == nil
        created_at = ''
      else
        created_at_parsed = row[6].to_datetime
      end
      if row[7] == nil
        updated_at = ''
      else
        updated_at_parsed = row[7].to_datetime
      end



      user_record = User.where(email: row[2]).first
      if !user_record
        user = User.new
        user.id = row[0]
        user.username = row[1]
        user.email = row[2]
        user.first_name = row[3]
        user.last_name = row[4]
        user.password = '49SNz!9Dk%xp' + row[3]
        user.password_confirmation = '49SNz!9Dk%xp' + row[3]
        user.user_source = 'db'
        user.user_group = 'FACULTY'
        user.is_active = true
        user.is_verified = true
        user.created_at = created_at_parsed
        user.updated_at = updated_at_parsed
        user.save!

        puts "Created user #{user.first_name} #{user.last_name}"
      else
        puts "User #{user_record.id}::#{user_record.name} already exists, skipping"
      end
    end
  end
end
