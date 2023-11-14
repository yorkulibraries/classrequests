FactoryBot.define do
  # create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  #   t.string "email", default: "", null: false
  #   t.string "encrypted_password", default: "", null: false
  #   t.string "reset_password_token"
  #   t.datetime "reset_password_sent_at"
  #   t.datetime "remember_created_at"
  #   t.datetime "created_at", precision: 6, null: false
  #   t.datetime "updated_at", precision: 6, null: false
  #   t.integer "sign_in_count", default: 0, null: false
  #   t.datetime "current_sign_in_at"
  #   t.datetime "last_sign_in_at"
  #   t.string "current_sign_in_ip"
  #   t.string "last_sign_in_ip"
  #   t.string "user_uid"
  #   t.string "username"
  #   t.string "first_name"
  #   t.string "last_name"
  #   t.string "contact_phone"
  #   t.string "alternate_email"
  #   t.string "user_source", default: "db"
  #   t.string "user_group", default: ""
  #   t.string "iam_identification", default: "YorkU Instructor"
  #   t.boolean "is_active", default: true
  #   t.boolean "is_verified", default: false
  #   t.datetime "announcements_last_read_at"
  #   t.text "note"
  #   t.index ["email"], name: "index_users_on_email", unique: true
  #   t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  #   t.index ["user_uid"], name: "index_users_on_user_uid"
  #   t.index ["username"], name: "index_users_on_username"
  # end

  factory :user do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    email { "#{first_name}.#{last_name}@mailinator.com".downcase }
    password { Faker::Internet.password }
    username {"#{first_name.str.chr}#{last_name}"}
    # first_name {'Homer'}
    # last_name {'Simpson'}
  end

  factory :valid_patron, class: User do
    email { "facultyrequestor@mailinator.com" }
    username {"faculty-requestor"}
    password { Faker::Internet.password }
    first_name {"John"}
    last_name {Faker::Name.last_name}
    contact_phone {"416-222-2345"}
    is_active { true}
    is_verified { false}
    user_uid { 111222333}
    alternate_email { Faker::Internet.email}
    user_source { "db"}
    user_group { "Faculty"}
    iam_identification { "YorkU Instructor"}
    note { Faker::Lorem.paragraph(sentence_count: 2)}

  end

end
