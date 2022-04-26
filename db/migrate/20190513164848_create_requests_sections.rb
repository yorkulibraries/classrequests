class CreateRequestsSections < ActiveRecord::Migration[5.1]
  def change
    create_table :requests_sections do |t|
      t.references :request, foreign_key: true
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
