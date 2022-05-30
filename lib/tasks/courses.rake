require 'json'
require 'date'
require 'csv'

namespace :courses do

  task init: :environment do

    ## LOAD DATA SCRAPED FROM YUL ICAL
    Rake::Task['courses:delete_institute_data'].invoke
    Rake::Task['courses:load_ical_data'].invoke
    Rake::Task['courses:remove_duplicate_courses'].invoke
    Rake::Task['courses:populate_missing_data'].invoke

  end

  task update: :environment do
    Rake::Task['courses:load_ical_data'].invoke
    Rake::Task['courses:remove_duplicate_courses'].invoke
  end

  task populate_missing_data: :environment do
    Rake::Task['courses:populate_faculties_names'].invoke
    Rake::Task['courses:populate_subject_names'].invoke
    Rake::Task['courses:populate_year_level'].invoke
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

  ## FIRST
  task load_ical_data: :environment do

    # Example Data
    # {"full_course_string": "2018_AP_LASO_Y_3365__6_A_EN_A_LECT_01", "year": "2018", "faculty_abbrev": "AP", "subject_abbrev": "LASO", "term": "Y", "course_number": "3365", "credits": "6", "section": "A", "language": "EN", "unknown_letter": "A", "section_format": "LECT", "section_group": "01"},

    #data_file = File.join(Rails.root, 'lib', 'assets', 'yuCourses_2018_19_20.json')
    # data_file = File.join(Rails.root, 'lib', 'assets', 'yuCourses_2020_only.json')
    # data_file = File.join(Rails.root, 'lib', 'assets', 'yuCourses_2021_only.json')
    data_file = File.join(Rails.root, 'lib', 'assets', 'yuCourses_2022_only.json')
    #data_file = File.join(Rails.root, 'lib', 'assets', 'yuCourses_2018_2019_2020_only.json')

    records = JSON.parse(File.read(data_file))
    dup_count = 0
    new_count = 0
    record_count = 0
    records.each do |record|

      record_count = record_count + 1

      line_input = record.to_h
      puts line_input["full_course_string"]
      academic_year = ""

      ## SPECIAL STEP
      ## Academic Year is from Sept to Aug and therefore e.g. data year is 2017 for
      ## any course that is in Sept 2017 until Aug 2018.
      ## We need to convert this to format 2017-2018 for import and user

      if line_input["year"] && line_input["year"].length == 4
        year_read = Date.new(line_input["year"].to_i, 01, 01).strftime("%Y")
        year_next = Date.new(line_input["year"].to_i+1, 01, 01).strftime("%Y")
        # puts "Year Read #{year_read}"
        # puts "Year Next #{year_next}"
        academic_year = "#{year_read}-#{year_next}"
        # puts "ACADEMIC YEAR: #{academic_year}"
      else
        academic_year = line_input["year"]
        puts "ALERT: Import Year is longer than four characters"
        puts "Please fix the data before proceeding"
        exit
      end


      ## Check if course exists: year, faculty, subject, number,
      ## {"full_course_string": "2017_AP_ADMB_S2_4799__0_M_EN_C_ONLN_01", "year": "2017", "faculty_abbrev": "AP", "subject_abbrev": "ADMB", "term": "S2", "course_number": "4799", "credits": "0", "section": "M", "language": "EN", "misc": "C", "section_format": "ONLN", "section_group": "01"}


      institute_course = InstituteCourse.where(
        academic_year: academic_year,
        faculty_abbrev: line_input["faculty_abbrev"],
        subject_abbrev: line_input["subject_abbrev"],
        number: line_input["course_number"],
        # credits: line_input["credits"],
        #title: "", faculty: "", subject: "",
        academic_term: line_input["term"]
      )
      if institute_course.empty?
        puts "I did not find it, creating course"
        new_course_record = InstituteCourse.new(
          academic_year: academic_year,
          faculty_abbrev: line_input["faculty_abbrev"],
          subject_abbrev: line_input["subject_abbrev"],
          number: line_input["course_number"],
          # credits: line_input["credits"],
          # title: "", faculty: "", subject: "",
          academic_term: line_input["term"]
        )
        new_course_record.save
        puts "ADDED Course: #{new_course_record.academic_year} | #{new_course_record.faculty_abbrev} | #{new_course_record.subject_abbrev} | #{new_course_record.number} | #{new_course_record.academic_term}"
        new_count = new_count + 1
        # puts "Also adding the section"
        # new_section_record = InstituteCourseSection.new(
        #   institute_course: new_course_record,
        #   name: line_input["section"], language: line_input["language"],
        #   section_format: line_input["section_format"],
        #   section_group: line_input["section_group"], misc: line_input["misc"]
        # )
        # new_section_record.save

      else
        # puts institute_course.ai
        puts "Course Exists: I Found  + #{institute_course.first.academic_year} - #{institute_course.first.faculty_abbrev} / #{institute_course.first.subject_abbrev}"
        puts "Using Course ID: #{institute_course.first.id}"
        dup_count = dup_count + 1
        # puts "Checking if Section Exists"
        # institute_course_section = InstituteCourseSection.where(
        #   institute_course: institute_course.first,
        #   name: line_input["section"], language: line_input["language"],
        #   section_format: line_input["section_format"],
        #   section_group: line_input["section_group"], misc: line_input["misc"]
        # )
        # if institute_course_section.empty?
        #   puts "This course does not have this section, adding it"
        #   new_section_record = InstituteCourseSection.new(
        #     institute_course: institute_course.first,
        #     name: line_input["section"], language: line_input["language"],
        #     section_format: line_input["section_format"],
        #     section_group: line_input["section_group"], misc: line_input["misc"]
        #   )
        #   new_section_record.save

          # puts "Existing Course: #{institute_course.first.id} #{line_input["full_course_string"]}"

          # puts "ADDED Section: #{new_section_record.name} | #{new_section_record.language} | #{new_section_record.section_group} | #{new_section_record.section_format} | #{new_section_record.misc}"

        # else
        #   puts "This course has this section already...skipping"
        #   puts "--> #{institute_course_section.ai}"
        #
        # end
      end # else
    end
    puts "Record Count: #{record_count}"
    puts "New Count: #{new_count}"
    puts "Dup Count: #{dup_count}"
  end

  ## SECOND
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

  ## THIRD
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
        # Before rails 6 is update_attributes, post is just update
        # fac.update_attributes(faculty: faculty)
        fac.update(faculty: faculty)
        no_of_records_updated = no_of_records_updated + 1
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

  ## FOURTH
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
      # puts "#{subject_abbrev}::#{subject} - Found #{no_of_records_found}"
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

  ## FIFTH
  task populate_year_level: :environment do

    puts "POPULATING YEAR LEVELS"
    ic = InstituteCourse.all
    ic_count = 0
    ic.each do |course|
      # puts course.number
      # course.year_level = course.number.to_s.split('').first
      # puts course.year_level
      # course.update_attribute :year_level, course.number.to_s.split('').first
      course.update(year_level: course.number.to_s.split('').first)
      # ic_count = ic_count + 1
      # if ic_count > 5
      #   exit
      # end

    end
  end

  ## SIXTH
  task insert_other_depts: :environment do

    puts "INSERTING OTHER OPTIONS"
    ## Add Other for all faculties
    grouped = InstituteCourse.all.group(:faculty_abbrev, :academic_year)
    grouped.each do |ic|
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
      # puts new_course_record.ai
    end

    ## Add Library faculty
    academic_years = InstituteCourse.select(:academic_year).distinct
    academic_years.each do |ay|
      library_faculty = InstituteCourse.new(
        academic_year: ay[:academic_year],
        faculty_abbrev: "LIB",
        faculty: "Library",
        subject: "Other / Internal",
        subject_abbrev: "OTHER",
        number: 0000,
        # credits: line_input["credits"],
        # title: "", faculty: "", subject: "",
        academic_term: "N/A"
      )
      library_faculty.save
      # puts library_faculty.ai

    end # TASK END
  end
end
