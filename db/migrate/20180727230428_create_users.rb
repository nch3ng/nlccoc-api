class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.references :role, foreign_key: true
      t.references :org, index: true, foreign_key: {to_table: :organizations}
      t.string :salt
      t.string :hash_key
      t.string :first_name
      t.string :last_name
      t.boolean :validated
      t.string :email

      t.timestamps
    end
  end
end
