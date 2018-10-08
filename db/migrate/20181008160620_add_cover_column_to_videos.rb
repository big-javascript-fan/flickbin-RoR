class AddCoverColumnToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :cover, :string
  end
end
