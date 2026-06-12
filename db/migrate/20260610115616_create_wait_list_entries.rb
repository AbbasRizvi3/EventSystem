class CreateWaitListEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :wait_list_entries do |t|
      t.timestamps
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :position, null: false
    end
    add_index :wait_list_entries, [ :user_id, :event_id ], unique: true
  end
end
