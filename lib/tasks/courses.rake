require 'json'
require 'date'
require 'csv'

namespace :courses do

  task init: :environment do

    ## LOAD DATA SCRAPED FROM YUL ICAL
    Rake::Task['courses:delete_institute_data'].invoke    
    Rake::Task['courses:load_yorku_data'].invoke
    Rake::Task['courses:populate_missing_data'].invoke
  end

  task update: :environment do
    Rake::Task['courses:load_yorku_data'].invoke
    Rake::Task['courses:populate_missing_data'].invoke
  end

  task populate_missing_data: :environment do
    Rake::Task['courses:populate_faculties_names'].invoke
    Rake::Task['courses:populate_subject_names'].invoke
    # Rake::Task['courses:populate_year_level'].invoke
    Rake::Task['courses:insert_library_faculty'].invoke
    Rake::Task['courses:insert_other_depts'].invoke
  end


  ########################################
  ### INTERNAL USAGE #####################
  ########################################

  #PRE-OPTIONAL
  task delete_institute_data: :environment do
    puts "DELETING INSTITUTE DATA"
    [InstituteCourse].each(&:delete_all)
  end

  ########################################
  ## 2025 - New Courses Source ###########
  ########################################

  desc "Loads course data from a CSV file. Pass the file path as an argument, e.g., 'rake courses:load_courses[./my_data.csv]'"
  task :load_courses, [:file_path] => :environment do |t, args|
    require 'csv'

    # --- Argument Handling and File Path Determination ---
    data_file_path = args[:file_path] # Get the argument if provided

    if data_file_path.nil? || data_file_path.empty?
      # If no argument, try the default path
      data_file_path = File.join(Rails.root, 'lib', 'assets', 'course-data', 'courses_2024-2025.csv')
      puts "No file path provided. Attempting to load from default: #{data_file_path}"
    else
      # If an argument is provided, ensure it's an absolute path or relative to Rails.root
      # For simplicity, if not absolute, treat as relative to Rails.root
      data_file_path = File.expand_path(data_file_path, Rails.root)
      puts "Loading from specified path: #{data_file_path}"
    end

    # --- File Existence Check ---
    unless File.exist?(data_file_path)
      $stderr.puts "Error: File not found at '#{data_file_path}'"
      exit(1) # Exit with a non-zero status to indicate an error
    end
    # --- End Argument Handling ---

    # Define a method to escape characters (keep this if you need it, though Simple Form often handles quoting)
    # Note: `escape_and_quote` is not used in the `find_by` section which is commented out.
    # ActiveRecord handles escaping values automatically when using `create` or `find_by`.
    def escape_and_quote(str)
      # This method is for preparing string for raw SQL, not typically needed for ActiveRecord
      str ? "'#{str.gsub(/[\"\'\,]/, '\\\\\0')}'" : nil
    end

    new_records_count = 0
    existing_records_count = 0

    puts "Starting course data import from: #{data_file_path}"

    # Loop through each row in the CSV file
    CSV.foreach(data_file_path, headers: true) do |row|
      # Extract data from each row - using `row[]` directly for values
      # Note: No need to `escape_and_quote` when passing to ActiveRecord methods like `find_or_create_by` or `create`
      academic_term    = row['STUDYSESSION']
      academic_year    = row['ACADEMICYEAR']
      faculty          = row['FACULTY']
      faculty_abbrev   = row['FACULTY_ABREV']
      subject          = row['SUBJECT']
      subject_abbrev   = row['SUBJECT_ABREV']
      title            = row['COURSETITLE']
      course_number    = row['COURSE_NUMBER']
      course_credits   = row['CREDIT'] # Note: You might want to convert this to integer or float

      puts "\n***********\n"
      puts "#{academic_term},#{academic_year}, #{faculty}, #{faculty_abbrev}, #{subject}, #{subject_abbrev}, #{title}, #{course_number}, #{course_credits}\n"

      # Check if the course already exists in the InstituteCourse table
      institute_course = InstituteCourse.find_by(academic_term: academic_term, academic_year: academic_year, faculty_abbrev: faculty_abbrev, faculty: faculty, subject: subject, subject_abbrev: subject_abbrev, title: title, number:course_number, credits:course_credits)

      if institute_course.nil?
        puts "Course not found, creating new record...\n"
        # Create a new InstituteCourse record
        InstituteCourse.create!(
          academic_term: academic_term,
          academic_year: academic_year,
          faculty: faculty,
          faculty_abbrev: faculty_abbrev,
          subject: subject,
          subject_abbrev: subject_abbrev,
          title: title,
          number:course_number,
          credits:course_credits
        )
        new_records_count += 1 
      else
        puts "Course already exists: #{faculty}, #{faculty_abbrev}, #{subject}, #{subject_abbrev}, #{title}, #{course_number}, #{course_credits}\n"
        existing_records_count += 1 
      end
      puts "***********\n"
      
    end # End CSV.foreach

    puts "\n--- Import Summary ---"
    puts "New records created: #{new_records_count}"
    puts "Existing records found (not created): #{existing_records_count}"
    puts "Total rows processed: #{new_records_count + existing_records_count}"

  end # End task

  ########################################
  ## 2024 ################################
  ########################################
  ## FIRST
  task load_yorku_data: :environment do 
    require 'csv'

    # Define a method to escape characters
    def escape_and_quote(str)
      # Escape characters and wrap in single quotes
      escaped_str = str.gsub(/[\"\'\,]/, '\\\\\0') if str
      # "'#{escaped_str}'"
    end

    # Example Data
    # academic_term,academic_year,faculty,faculty_abbrev,subject,subject_abbrev,title

    # Directory containing CSV files
    csv_directory = File.join(Rails.root, 'lib', 'assets', 'course-data')
    new_records_count = 0
    existing_records_count = 0

    # Loop through each CSV file in the directory
    Dir.glob(File.join(csv_directory, '*.csv')).each do |data_file|
      puts "Processing file: #{data_file}"

      # Loop through each row in the CSV file
      CSV.foreach(data_file, headers: true) do |row|
        # Extract data from each row
        academic_term = escape_and_quote(row['academic_term'])
        academic_year = escape_and_quote(row['academic_year'])
        faculty = escape_and_quote(row['faculty'])
        faculty_abbrev = escape_and_quote(row['faculty_abbrev'])
        subject = escape_and_quote(row['subject'])
        subject_abbrev = escape_and_quote(row['subject_abbrev'])
        title = escape_and_quote(row['title'])
        course_number = escape_and_quote(row['course_number_raw'])
        course_credits = escape_and_quote(row['course_credits_raw'])

        puts "\n***********\n"
        puts "#{academic_term},#{academic_year}, #{faculty}, #{faculty_abbrev}, #{subject}, #{subject_abbrev}, #{title}, #{course_number}, #{course_credits}\n"

        # Check if the course already exists in the InstituteCourse table
        institute_course = InstituteCourse.find_by(academic_term: academic_term, academic_year: academic_year, faculty_abbrev: faculty_abbrev, faculty: faculty, subject: subject, subject_abbrev: subject_abbrev, title: title, number:course_number, credits:course_credits)

        if institute_course.nil?
          puts "Course not found, creating new record...\n"
          # Create a new InstituteCourse record
          InstituteCourse.create!(
            academic_term: academic_term,
            academic_year: academic_year,
            faculty: faculty,
            faculty_abbrev: faculty_abbrev,
            subject: subject,
            subject_abbrev: subject_abbrev,
            title: title,
            number:course_number,
            credits:course_credits
          )
          new_records_count += 1 
        else
          puts "Course already exists: #{faculty}, #{faculty_abbrev}, #{subject}, #{subject_abbrev}, #{title}, #{course_number}, #{course_credits}\n"
          existing_records_count += 1 
        end
        puts "***********\n"
      end
    end

    puts "==============="
    puts "New Records Added: #{new_records_count}"
    puts "Existing Records Skipped: #{existing_records_count}"
    puts "==============="
  end

  ## SECOND
  task populate_faculties_names: :environment do

    puts "POPULATING FACULTY NAMES"

    linecounter = 0; no_of_records_found = 0;
    no_of_records_updated = 0; skipped = 0;
    data_file_3 = File.join(Rails.root, 'lib', 'assets', 'course_faculties.csv')
    # data_file_missing = File.join(Rails.root, 'lib', 'assets', 'course_faculties_missing.csv')

    #Loop through file
    CSV.foreach(data_file_3, headers: false) do |row|
      faculty_abbrev = row[0].strip
      faculty = row[1].strip

      linecounter = linecounter + 1
      @faculties = InstituteCourse.where(faculty_abbrev: faculty_abbrev)
      no_of_records_found = @faculties.count
      puts "#{faculty_abbrev}::#{faculty} - Found #{no_of_records_found}"

      # Update database tables
      @faculties.each do |fac|
        if fac.faculty != faculty 
          fac.update(faculty: faculty)
          no_of_records_updated = no_of_records_updated + 1
        end
      end
      skipped =  no_of_records_found - no_of_records_updated
      puts "Updated: #{no_of_records_updated } - Skipped: #{skipped}"
      no_of_records_updated = 0
    end ## foreach

    puts "****************************************"
    puts "*** Facilty Records that Need Your attention ***"
    @notupdated = InstituteCourse.where(faculty: "")
    if(!@notupdated.empty?)
      @notupdated.each do |nu|
        puts "**** #{nu.id} - #{nu.faculty_abbrev}"
      end
    else
      puts "**** None"
    end
    puts "****************************************"

  end

  ## THIRD
  task populate_subject_names: :environment do

    puts "POPULATING SUBJECT NAMES"
    linecounter = 0; no_of_records_found = 0;
    no_of_records_updated = 0; skipped = 0;
    data_file_2 = File.join(Rails.root, 'lib', 'assets', 'course_subjects.csv')

    #Loop through file
    CSV.foreach(data_file_2, headers: false) do |row|
      subject_abbrev = row[0].strip
      subject = row[1].strip

      linecounter = linecounter + 1
      @subject = InstituteCourse.where(subject_abbrev: subject_abbrev).where("subject is NULL")
      # puts @subject.inspect
      no_of_records_found = @subject.count
      puts "#{subject_abbrev}::#{subject} - Found #{no_of_records_found}"
      # Update database tables
      @subject.each do |sub|
        # puts "Before: #{sub.inspect}"
        # Before rails 6 is update_attributes, post is just update
          sub.update(subject: subject)
        # puts "After: #{sub.inspect}"
        no_of_records_updated = no_of_records_updated + 1
      end
      skipped =  no_of_records_found - no_of_records_updated
      if no_of_records_updated != 0 || skipped != 0
        puts "#{subject_abbrev}::#{subject} - Updated: #{no_of_records_updated } - Skipped: #{skipped}"
      end
      no_of_records_updated = 0
    end ## foreach

    puts "****************************************"
    puts "*** Subject Records that Need Your attention ***"
    @notupdated = InstituteCourse.where("subject is NULL or subject = ''")
    if(!@notupdated.empty?)
      @notupdated.each do |nu|
        puts "#{nu.faculty_abbrev} - #{nu.subject_abbrev}::#{nu.number} "
      end
    else
      puts "**** None"
    end
    puts "****************************************"

  end

  ## FOUTH
  task insert_library_faculty: :environment do

    puts "\nINSERTING LIBRARY FACULTY"
  
    ## Add Library faculty
    academic_years = InstituteCourse.select(:academic_year).distinct

    academic_years.each do |ay|
      library_faculty_check = InstituteCourse.find_by(academic_term: "N/A", academic_year: ay[:academic_year], faculty_abbrev: "LIB", faculty: "Library", subject: "Other / Internal", subject_abbrev: "OTHER")

      if library_faculty_check.nil? 

        library_faculty = InstituteCourse.new(
          academic_year: ay[:academic_year],
          faculty_abbrev: "LIB",
          faculty: "Library",
          subject: "Other / Internal",
          subject_abbrev: "OTHER",
          # number: 0000,
          # credits: line_input["credits"],
          # title: "", faculty: "", subject: "",
          academic_term: "N/A"
        )
        library_faculty.save
        puts "Added Other Library Faculty (LIB) for #{ay[:academic_year]}"
      else 
        puts "** Other Faculty exists for #{ay[:academic_year]}"
      end

    end # TASK END
  end

  ## FIFTH
  task insert_other_depts: :environment do

    puts "\nINSERTING OTHER OPTIONS"
    ## Add Other for all faculties
    grouped = InstituteCourse.all.group(:faculty_abbrev, :academic_year)
    # grouped = InstituteCourse.select("academic_year, faculty_abbrev, faculty, subject, subject_abbrev, number, academic_term, COUNT (*) as count").group(:faculty_abbrev, :academic_year)
    
    grouped.each do |ic|
      # Check if the course already exists in the InstituteCourse table
      institute_course = InstituteCourse.find_by(academic_term: "N/A", academic_year: ic.academic_year, faculty_abbrev: ic.faculty_abbrev, faculty: ic.faculty, subject: "Other / New Subject", subject_abbrev: "OTHER", number: 0000)

      if institute_course.nil?
        new_course_record = InstituteCourse.new(
          academic_year: ic.academic_year,
          faculty_abbrev: ic.faculty_abbrev,
          faculty: ic.faculty,
          subject: "Other / New Subject",
          subject_abbrev: "OTHER",
          number: 0000,
          # credits: ic["credits"],
          # title: "",
          academic_term: "N/A"
        )
        new_course_record.save
        puts "Added Other Subject for #{ic.faculty}"
      else
        puts "** Other Subject exists for #{ic.faculty}"
      end
    end
  end # Task end

  ####################################################
  ## IF NEEDED, OTHERWISE OBSOLETE by end of 2024 #####
  ####################################################
  task remove_duplicate_courses: :environment do

    puts "REMOVING DUPlICATED COURSES"
    dup_count = 0
    grouped = InstituteCourse.all.group_by{|model| [model.faculty_abbrev, model.subject_abbrev, model.academic_year, model.number]}

    # grouped_count = InstituteCourse.all.group_by{|model| [model.faculty_abbrev, model.subject_abbrev, model.academic_year, model.number]}.count

    puts "Total Insititute Courses: #{InstituteCourse.all.count}"
    puts "Uniquie Insititute Courses: #{grouped.count}"
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each do |double|
        double.destroy # duplicates can now be destroyed
        dup_count = dup_count + 1
      end
    end
    puts "Duplicate Removed #{dup_count}"
  end

  task populate_year_level: :environment do

    puts "POPULATING YEAR LEVELS"
    ic = InstituteCourse.all
    ic_count = 0
    ic.each do |course|
      # puts course.number
      # course.year_level = course.number.to_s.split('').first
      puts course.year_level if course.year_level != ''
      # course.update_attribute :year_level, course.number.to_s.split('').first
      course.update(year_level: course.number.to_s.split('').first)
      # ic_count = ic_count + 1
      # if ic_count > 5
      #   exit
      # end

    end
  end

end
