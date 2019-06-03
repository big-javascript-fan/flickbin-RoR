class UpdateVideoForHomePagesToVersion2 < ActiveRecord::Migration[5.1]
  def change
    update_view :video_for_home_pages, version: 2, revert_to_version: 1
  end
end
