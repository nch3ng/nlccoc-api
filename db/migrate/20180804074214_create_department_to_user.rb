class CreateDepartmentToUser < ActiveRecord::Migration[5.2]
  def change
    create_table :department_to_users do |t|
      add_column :users, :department_id, :integer, :references => "departments"
    end
  end
end
