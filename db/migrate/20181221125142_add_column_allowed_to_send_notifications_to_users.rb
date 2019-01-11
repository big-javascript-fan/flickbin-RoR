class AddColumnAllowedToSendNotificationsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :allowed_to_send_notifications, :boolean, default: true
  end
end
