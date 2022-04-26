class CreateStaffProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_profiles do |t|
      t.string :specializtion_job_title
      t.text :profile_bio
      t.string :role
      t.references :department, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :is_approved

      t.timestamps
    end
  end
end
