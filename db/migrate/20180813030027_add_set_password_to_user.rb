class AddSetPasswordToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :setPassword, :boolean
  end
end
