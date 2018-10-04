class AddChannelDescriptionAndAvatarToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :channel_description, :text
    add_column :users, :avatar, :string
  end
end
