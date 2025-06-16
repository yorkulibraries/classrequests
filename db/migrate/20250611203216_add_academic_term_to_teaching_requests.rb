class AddAcademicTermToTeachingRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :teaching_requests, :academic_term, :string, default: "Missing"
  end
end
