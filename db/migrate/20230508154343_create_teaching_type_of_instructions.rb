class CreateTeachingTypeOfInstructions < ActiveRecord::Migration[6.1]
  def change
    create_table :teaching_type_of_instructions do |t|
      t.references :teaching_request, null: false, foreign_key: true
      t.references :type_of_instruction, null: false, foreign_key: true

      t.timestamps
    end
  end
end
