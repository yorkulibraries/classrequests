class CreateSubjectPortfolioDeclines < ActiveRecord::Migration[7.2]
  def change
    create_table :subject_portfolio_declines do |t|
      t.references :teaching_request, null: false, foreign_key: true
      t.references :subject_portfolio, null: false, foreign_key: true
      t.references :declined_by,
                   null: false,
                   foreign_key: { to_table: :users }
      t.text :reason, null: false

      t.timestamps
    end

    add_index :subject_portfolio_declines,
              [ :teaching_request_id, :created_at ],
              name: "index_portfolio_declines_on_request_and_created_at"
  end
end
