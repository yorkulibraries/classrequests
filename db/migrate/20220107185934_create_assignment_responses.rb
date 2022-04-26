class CreateAssignmentResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :assignment_responses do |t|
      t.string :response
      t.text :comment_or_reason
      t.references :teaching_request, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
