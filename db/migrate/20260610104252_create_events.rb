class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.timestamps
      t.string :title, null: false
      t.text :description
      t.string :location, null: false
      t.timestamp :start_time, null: false
      t.timestamp :end_time, null: false
      t.integer :capacity, null: false
      t.string :status, null: false, default: "active"

      t.references :user, null: false, foreign_key: true
    end
  end
end
