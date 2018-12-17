class AddReadColumnToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :read, :boolean, default: false
  end
end
