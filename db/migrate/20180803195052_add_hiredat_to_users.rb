class AddHiredatToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hired_at, :date
  end
end
