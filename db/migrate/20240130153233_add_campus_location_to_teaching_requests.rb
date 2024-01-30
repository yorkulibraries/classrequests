class AddCampusLocationToTeachingRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :teaching_requests, :campus_location, null: true, foreign_key: true
  end
end
