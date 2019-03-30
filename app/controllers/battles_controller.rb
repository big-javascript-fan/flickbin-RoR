class BattlesController < ApplicationController
  def show
    @sidebar_tags = get_sidebar_tags(70)
    @tag = Tag.friendly.find(params[:tag_slug])
    @tag_videos = @tag.videos.active.limit(10).includes(:user)
    @battle = Battle.last
  end
end
