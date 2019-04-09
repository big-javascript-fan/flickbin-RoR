class BattlesController < ApplicationController
  def show
    @sidebar_tags = get_sidebar_tags(70)
    @battle = Battle.find(params[:id])
    @tag_videos = @battle.tag.videos.active.limit(10).includes(:user)
    @current_user_voted_video_ids = current_user.votes.map(&:video_id) if current_user.present?
    @already_voted = CheckUserBattleVoteExistanceService.new(@battle, request.ip, current_user).call
    @voted_member_id = GetVotedMemberService.new(@battle, request.ip, current_user).call if @already_voted
    @rematch_request_sent = CheckUserBattleRematchRequestExistanceService.new(@battle, request.ip, current_user).call
  end
end
