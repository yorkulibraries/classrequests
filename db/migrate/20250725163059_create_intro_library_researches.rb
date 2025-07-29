class CreateIntroLibraryResearches < ActiveRecord::Migration[7.0]
  def change
    create_table :intro_library_researches do |t|
      t.string :username
      t.integer :patron_type
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.references :campus_location, null: true, foreign_key: true
      t.string :academic_term, default: "Missing"
      t.string :academic_year
      t.string :faculty
      t.string :faculty_abbrev
      t.string :subject
      t.string :subject_abbrev
      t.integer :course_number
      t.string :course_title
      t.string :section_name_or_about
      t.string :status
      t.string :submitted_by
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
