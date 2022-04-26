class CreateInstituteCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :institute_courses do |t|
      t.string :faculty
      t.string :faculty_abbrev
      t.string :subject
      t.string :subject_abbrev
      t.string :academic_term
      t.string :academic_year
      t.string :year_level
      t.string :professor
      t.integer :number
      t.integer :credits
      t.string :title
      t.string :title2
      t.string :section

      t.timestamps
    end
  end
end
