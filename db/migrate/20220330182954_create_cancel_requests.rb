class CreateCancelRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :cancel_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :teaching_request, null: false, foreign_key: true
      t.text :reason

      t.timestamps
    end
  end
end
