class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.text :message
      t.string :category
      t.json :event_object
      t.index :user_id

      t.timestamps
    end
  end
end
