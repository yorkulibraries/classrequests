json.extract! staff_profile, :id, :specializtion_job_title, :profile_bio, :role, :department_id, :user_id,
              :is_approved, :created_at, :updated_at
json.url staff_profile_url(staff_profile, format: :json)
