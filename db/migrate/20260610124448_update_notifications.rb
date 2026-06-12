class UpdateNotifications < ActiveRecord::Migration[8.1]
  def change
  remove_column :notifications, :message, :string
  add_column :notifications, :title, :string, null: false, default: ""
  add_column :notifications, :body, :text, null: false, default: ""
  end
end
