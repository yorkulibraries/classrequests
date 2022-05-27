require 'json'
require 'date'

namespace :old_data do

  ## LOAD OLD Data
  task existing_teaching_data: :environment do
    require 'date'

    linecounter = 0; no_of_records_found = 0;
    no_of_records_updated = 0; skipped = 0;

    ## Read the export csv
    # data_file = File.join(Rails.root, 'lib', 'assets', 'classrequests_data_feb25-headers-withoutnote.csv')
    data_file = File.join(Rails.root, 'lib', 'assets', 'classrequests_data_may27-headers-withoutnotes.csv')

    ## Loop each line
    CSV.foreach(data_file, headers: true) do |row|
      linecounter = linecounter + 1
      preferred_date_parsed = ''

      # puts "********* BEFORE ********* "
      # puts "\n username: #{row[0]},
      # patron_type: #{row[1]},
      # first_name: #{row[2]},
      # last_name: #{row[3]},
      # email: #{row[4]},
      # phone: #{row[5]},
      # academic_year: #{row[6]},
      # faculty: #{row[7]},
      # faculty_abbrev: #{row[8]} ,
      # subject: #{row[9]},
      # subject_abbrev:#{row[10]} ,
      # course_title: #{row[11]},
      # course_number: #{row[12]},
      # submitted_by: #{row[13]},
      # submitted_on_behalf: '',
      # section_name_or_about: #{row[14]},
      # number_of_students: #{row[15]},
      # preferred_date: #{row[16]},
      # preferred_time: #{row[17]},
      # alternate_date: #{row[18]},
      # alternate_time: #{row[19]},
      # duration: #{row[20]},
      # room: #{row[21]},
      # lead_instructor_id: #{row[22]},
      # second_instructor_id: #{row[23]},
      # third_instructor_id: #{row[24]},
      # status: #{row[25]},
      # request_note: 'old-data-notes-not-copied',
      # instructor_notes: '',
      # user_id: 0,
      # created_at: #{row[26]},
      # updated_at: #{row[27]}"

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
      location_parsed = ''

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
      else
        location_parsed = ''
      end

      ## Duration Fix
      # enumerize :duration, in: { thirty: '30', sixty: '60', sixty_plus: '60+', ninety: '90', one_twenty: '120', one_eighty: '180', one_eighty_plus: '180+' }
      if row[20] == "" || row[20] == " " || row[20] == nil
        row[20] = "30"

      elsif row[20].match(/(30|15|20|25)(\S*) (.*)/) || row[20].match(/(30|15|20|25|asynchronous|synchronous|Asychronous)(.*)/i) || row[20].match(/(to)(\S*) (.*)/)
        row[20] = "30"

      elsif row[20] == "60ish minutes" || row[20] == "60 MINUTES" || row[20] == "50 mins" ||
          row[20].match(/(40)(\S*) (.*)/) ||
          row[20] == "50" ||
          row[20].match(/(40|45|50|1)(\S*) (.*)/) || row[20] == "30-45" ||
          row[20].match(/(45|50|55|35|1 hr|1|one)(.*)/) ||
          row[20] == "1hr" ||
          row[20].match(/(.*)hour(.*)/)

        row[20] = "60"

      elsif row[20] == "75" || row[20] == "90" || row[20].match(/(1.5)(.*)/)
        row[20] = "90"

      elsif row[20] == "120" || row[20] == "2 hours" ||
            row[20].match(/(2|2hr|2 hours)(\S*) (.*)/) ||

        row[20] = "120"

      elsif row[20] == "180"
        row[20] = "180"
      elsif row[20] == "180+"
        row[20] = "180+"
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
      room: #{row[21]},
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
      #
      #   puts "#{linecounter} records added"
  end

  task existing_user_data: :environment do
    linecounter = 0; no_of_records_found = 0;
    no_of_records_updated = 0; skipped = 0;

    ## Read the export csv
    data_file = File.join(Rails.root, 'lib', 'assets', 'classrequests_data_may27-users.csv')

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
end #namespace
