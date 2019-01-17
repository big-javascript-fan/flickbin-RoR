class AddCommentCountToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :comments_count, :integer, default: 0
  end
end
