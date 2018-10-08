class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.integer :user_id
      t.integer :tag_id
      t.integer :rank

      t.timestamps
    end

    add_index :videos, [:url, :tag_id]
    add_index :videos, [:user_id, :tag_id]
    add_index :videos, :tag_id
    add_index :videos, :rank
  end
end
