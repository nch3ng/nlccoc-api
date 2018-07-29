class AddOrgRoleToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :org_role_id, :integer, :references => "roles"
  end
end
