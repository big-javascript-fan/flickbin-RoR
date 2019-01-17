class RenameColumnYoutubeIdToSourceId < ActiveRecord::Migration[5.1]
  def change
    rename_column :videos, :youtube_id, :source_id
  end
end
