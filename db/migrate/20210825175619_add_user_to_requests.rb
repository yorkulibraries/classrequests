class AddUserToRequests < ActiveRecord::Migration[6.1]
  def change
    add_reference :requests, :user, null: false
    add_foreign_key :requests, :users
  end
end
