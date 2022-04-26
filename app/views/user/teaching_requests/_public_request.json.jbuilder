json.extract! request, :id, :patron_type, :first_name, :last_name, :email, :phone, :academic_year, :faculty, :faculty_abbrev, :subject, :subject_abbrev, :course_title, :course_number, :submitted_by, :created_at, :updated_at
json.url request_url(request, format: :json)
