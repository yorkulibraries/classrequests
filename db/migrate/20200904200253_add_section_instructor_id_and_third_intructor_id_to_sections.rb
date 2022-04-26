class AddSectionInstructorIdAndThirdIntructorIdToSections < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :second_instructor_id, :integer
    add_column :sections, :third_instructor_id, :integer
  end
end
