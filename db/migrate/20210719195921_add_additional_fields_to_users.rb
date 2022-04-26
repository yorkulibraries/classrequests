class AddAdditionalFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
      #trackable
      add_column :users, :sign_in_count, :integer, default: 0, null: false
      add_column :users, :current_sign_in_at, :datetime
      add_column :users, :last_sign_in_at, :datetime
      add_column :users, :current_sign_in_ip, :string
      add_column :users, :last_sign_in_ip, :string

      #user-details
      add_column :users, :user_uid, :string
      add_column :users, :username, :string
      add_column :users, :first_name, :string
      add_column :users, :last_name, :string
      add_column :users, :contact_phone, :string
      add_column :users, :alternate_email, :string
      add_column :users, :user_source, :string, default: 'db'
      add_column :users, :user_group, :string, default: ''
      add_column :users, :iam_identification, :string, default: 'YorkU Instructor'
      add_column :users, :is_active, :boolean, default: true
      add_column :users, :is_verified, :boolean, default: false
      add_column :users, :announcements_last_read_at, :datetime
      add_column :users, :note, :text

      add_index :users, :user_uid
      add_index :users, :username




  end
end
