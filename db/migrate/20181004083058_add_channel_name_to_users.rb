class AddChannelNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :channel_name, :string
    add_index :users, :channel_name, unique: true
  end
end
