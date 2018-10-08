class AddSlugColumnToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :slug, :string
    add_index :videos, :slug, unique: true
  end
end
