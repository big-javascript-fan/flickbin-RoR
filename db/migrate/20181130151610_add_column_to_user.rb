class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fake_avatar_url, :string, default: ''
  end
end
