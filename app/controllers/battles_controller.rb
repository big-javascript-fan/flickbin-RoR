class BattlesController < ApplicationController
  def show
    @sidebar_tags = get_sidebar_tags(70)
    @tag = Tag.friendly.find(params[:tag_slug])
    @tag_videos = @tag.videos.active.limit(10).includes(:user)
    @battle = Battle.last
    @current_user_voted_video_ids = current_user.votes.map(&:video_id) if current_user.present?
  end
end
