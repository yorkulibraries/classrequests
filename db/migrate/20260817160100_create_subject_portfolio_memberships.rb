class CreateSubjectPortfolioMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :subject_portfolio_memberships do |t|
      t.references :subject_portfolio, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :subject_portfolio_memberships,
              [ :subject_portfolio_id, :user_id ],
              unique: true,
              name: "index_subject_portfolio_memberships_on_portfolio_and_user"
  end
end
