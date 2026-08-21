class AddSubjectPortfolioToTeachingRequests < ActiveRecord::Migration[7.2]
  def change
    add_reference :teaching_requests, :subject_portfolio, null: true, foreign_key: true
  end
end
