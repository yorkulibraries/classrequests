class CreateTypeOfInstructions < ActiveRecord::Migration[6.1]
  def change
    create_table :type_of_instructions do |t|
      t.string :name

      t.timestamps
    end
  end
end
