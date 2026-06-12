class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.timestamps
      t.string :name, null: false
    end
    add_index :roles, :name, unique: true
  end
end
