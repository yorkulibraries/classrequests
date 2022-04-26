class CreateTeachingRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :teaching_requests do |t|
      t.string :username
      t.string :patron_type
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :academic_year
      t.string :faculty
      t.string :faculty_abbrev
      t.string :subject
      t.string :subject_abbrev
      t.string :course_title
      t.integer :course_number
      t.string :submitted_by
      t.string :submitted_on_behalf
      t.string :section_name_or_about
      t.integer :number_of_students
      t.date :preferred_date
      t.time :preferred_time
      t.date :alternate_date
      t.time :alternate_time
      t.string :duration
      t.string :location_preference
      t.string :room
      t.integer :lead_instructor_id
      t.integer :second_instructor_id
      t.integer :third_instructor_id
      t.string :status, index: true
      t.text :request_note
      t.text :instructor_notes
      t.references :user

      t.timestamps
    end
  end
end
