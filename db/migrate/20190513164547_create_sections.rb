class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.string :section_name_or_about
      t.integer :number_of_students
      t.date :preferred_date
      t.time :preferred_time
      t.date :alternate_date
      t.time :alternate_time
      t.string :duration
      t.string :location_preference
      t.text :note
      t.integer :lead_instructor_id
      t.integer :status, default: 0, index: true

      t.timestamps
    end
  end
end
