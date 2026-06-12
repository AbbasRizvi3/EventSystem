class AddUniquenessToEventTitle < ActiveRecord::Migration[8.1]
  def change
    add_index :events, :title, unique: true
  end
end
