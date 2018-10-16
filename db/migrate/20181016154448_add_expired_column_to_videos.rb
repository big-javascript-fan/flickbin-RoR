class AddExpiredColumnToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :untagged, :boolean, default: false
  end
end
