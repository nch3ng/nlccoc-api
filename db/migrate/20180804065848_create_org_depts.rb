class CreateOrgDepts < ActiveRecord::Migration[5.2]
  def change
    create_table :org_depts do |t|
      t.integer :department_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
