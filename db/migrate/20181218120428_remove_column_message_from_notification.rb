class RemoveColumnMessageFromNotification < ActiveRecord::Migration[5.1]
  def change
    remove_column :notifications, :message, :text
  end
end
