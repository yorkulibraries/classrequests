class UpdateRoleIsApprovedDefaultsToStaffProfiles < ActiveRecord::Migration[6.1]
  def change

    change_column :staff_profiles, :role, :string, default: '0', null: false
    change_column :staff_profiles, :is_approved, :boolean, default: false



  end
end
