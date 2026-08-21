class CreateSubjectPortfolios < ActiveRecord::Migration[7.2]
  def change
    create_table :subject_portfolios do |t|
      t.string :name, null: false
      t.string :notification_email, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :subject_portfolios, :name, unique: true
  end
end
