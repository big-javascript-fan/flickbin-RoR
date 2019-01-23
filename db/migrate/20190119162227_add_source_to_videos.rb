class AddSourceToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :source, :string, default: ''
  end
end
