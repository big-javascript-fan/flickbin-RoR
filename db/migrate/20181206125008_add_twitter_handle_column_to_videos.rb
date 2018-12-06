class AddTwitterHandleColumnToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :twitter_handle, :string
  end
end
