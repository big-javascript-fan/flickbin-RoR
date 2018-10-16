class AddRemovedColumnToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :removed, :boolean, default: false
  end
end
