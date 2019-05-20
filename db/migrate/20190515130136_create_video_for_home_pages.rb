class CreateVideoForHomePages < ActiveRecord::Migration[5.1]
  def change
    create_view :video_for_home_pages
  end
end
