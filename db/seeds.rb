# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if (Rails.env == 'development')

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


    CampusLocation.create(name: 'Keele', address: "198 York Blvd, North York, ON M3J 2S5")
    CampusLocation.create(name: 'Glendon', address: "2275 Bayview Ave, North York, ON M4N 3M6" )
    CampusLocation.create(name: 'Markham', address: "1 University Blvd., Unionville, ON L6G 0A1")
    CampusLocation.create(name: 'Other', address: "")


    user_record = User.where(email: 'admin@mailinator.com').first
    if !user_record
      user = User.new
      user.first_name = 'Admin'
      user.last_name = 'Doe'
      user.email = 'admin@mailinator.com'
      user.password = 'ADMIN12345'
      user.password_confirmation = 'ADMIN12345'
      user.user_source = 'db'
      user.user_group = 'STAFF'
      user.is_verified = true
      user.user_uid = '666669420'
      user.save!

      puts "Created user #{user.first_name} #{user.last_name}"
      puts "Username: admin@mailinator.com"
      puts "Password: ADMIN12345"
    else
      puts "#{user_record.name} already exists, skipping"
    end

    user_record = User.where(email: 'admin@mailinator.com').first
    # puts user_record.ai

    if user_record
      staff_profile_check = StaffProfile.where(user_id: user_record.id).first
      puts staff_profile_check.ai
      if !staff_profile_check
        staff_role = StaffProfile.new
        staff_role.user = user_record
        staff_role.department = Department.first #note-to-self,create departments first
        staff_role.role = 9
        staff_role.is_approved = true
        staff_role.save!
        puts "Added staff profile for #{user_record.name} with role #{staff_role.role}"
      end
    else
      puts "Unable to find user"
    end

end