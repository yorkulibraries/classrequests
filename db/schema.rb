# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_06_145045) do

  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "published_at"
    t.string "announcement_type"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "assignment_responses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "response"
    t.text "comment_or_reason"
    t.bigint "teaching_request_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["teaching_request_id"], name: "index_assignment_responses_on_teaching_request_id"
    t.index ["user_id"], name: "index_assignment_responses_on_user_id"
  end

  create_table "cancel_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "teaching_request_id", null: false
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["teaching_request_id"], name: "index_cancel_requests_on_teaching_request_id"
    t.index ["user_id"], name: "index_cancel_requests_on_user_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "branch_division"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "institute_courses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "faculty"
    t.string "faculty_abbrev"
    t.string "subject"
    t.string "subject_abbrev"
    t.string "academic_term"
    t.string "academic_year"
    t.string "year_level"
    t.string "professor"
    t.integer "number"
    t.integer "credits"
    t.string "title"
    t.string "title2"
    t.string "section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.bigint "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.integer "patron_type"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "academic_year"
    t.string "faculty"
    t.string "faculty_abbrev"
    t.string "subject"
    t.string "subject_abbrev"
    t.string "course_title"
    t.integer "course_number"
    t.string "submitted_by"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["status"], name: "index_requests_on_status"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "requests_sections", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "request_id"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_requests_sections_on_request_id"
    t.index ["section_id"], name: "index_requests_sections_on_section_id"
  end

  create_table "sections", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "section_name_or_about"
    t.integer "number_of_students"
    t.date "preferred_date"
    t.time "preferred_time"
    t.date "alternate_date"
    t.time "alternate_time"
    t.string "duration"
    t.string "location_preference"
    t.text "note"
    t.integer "lead_instructor_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "second_instructor_id"
    t.integer "third_instructor_id"
    t.index ["status"], name: "index_sections_on_status"
  end

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "staff_profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "specializtion_job_title"
    t.text "profile_bio"
    t.string "role", default: "0", null: false
    t.bigint "department_id", null: false
    t.bigint "user_id", null: false
    t.boolean "is_approved", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["department_id"], name: "index_staff_profiles_on_department_id"
    t.index ["user_id"], name: "index_staff_profiles_on_user_id"
  end

  create_table "teaching_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "patron_type"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "academic_year"
    t.string "faculty"
    t.string "faculty_abbrev"
    t.string "subject"
    t.string "subject_abbrev"
    t.string "course_title"
    t.integer "course_number"
    t.string "submitted_by"
    t.string "submitted_on_behalf"
    t.string "section_name_or_about"
    t.integer "number_of_students"
    t.date "preferred_date"
    t.time "preferred_time"
    t.date "alternate_date"
    t.time "alternate_time"
    t.string "duration"
    t.string "location_preference"
    t.string "room"
    t.integer "lead_instructor_id"
    t.integer "second_instructor_id"
    t.integer "third_instructor_id"
    t.string "status"
    t.text "request_note"
    t.text "instructor_notes"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status"], name: "index_teaching_requests_on_status"
    t.index ["user_id"], name: "index_teaching_requests_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "user_uid"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "contact_phone"
    t.string "alternate_email"
    t.string "user_source", default: "db"
    t.string "user_group", default: ""
    t.string "iam_identification", default: "YorkU Instructor"
    t.boolean "is_active", default: true
    t.boolean "is_verified", default: false
    t.datetime "announcements_last_read_at"
    t.text "note"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_uid"], name: "index_users_on_user_uid"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignment_responses", "teaching_requests"
  add_foreign_key "assignment_responses", "users"
  add_foreign_key "cancel_requests", "teaching_requests"
  add_foreign_key "cancel_requests", "users"
  add_foreign_key "requests", "users"
  add_foreign_key "requests_sections", "requests"
  add_foreign_key "requests_sections", "sections"
  add_foreign_key "staff_profiles", "departments"
  add_foreign_key "staff_profiles", "users"
end
