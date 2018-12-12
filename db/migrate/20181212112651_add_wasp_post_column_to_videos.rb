class AddWaspPostColumnToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :wasp_post, :boolean, default: false
  end
end
