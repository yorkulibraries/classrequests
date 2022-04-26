class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :username
      t.integer :patron_type
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
      t.integer :status, default: 0, index: true

      t.timestamps
    end
  end
end
