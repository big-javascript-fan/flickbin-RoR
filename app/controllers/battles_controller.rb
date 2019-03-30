class BattlesController < ApplicationController
  def show
    @sidebar_tags = get_sidebar_tags(70)
    @battle = Battle.find(params[:id])
    @tag_videos = @battle.tag.videos.active.limit(10).includes(:user)
    @current_user_voted_video_ids = current_user.votes.map(&:video_id) if current_user.present?
    @already_voted = @battle.vote_ips.where(ip: request.ip, created_at: (Time.now - 1.day)...Time.now).any?
  end
end
