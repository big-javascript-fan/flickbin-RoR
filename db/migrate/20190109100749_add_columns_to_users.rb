class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :receive_notification_emails, :boolean, default: true
    add_column :users, :receive_promotional_emails, :boolean, default: true
  end
end
