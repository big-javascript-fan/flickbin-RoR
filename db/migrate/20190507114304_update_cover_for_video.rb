class UpdateCoverForVideo < ActiveRecord::Migration[5.1]
  def up
    # Rake::Task['update_cover_for_video:youtube'].invoke
    # Rake::Task['update_cover_for_video:twitch'].invoke
  end

  def down; end
end
