# frozen_string_literal: true

class BattlesController < ApplicationController
  before_action :battle, only: %i[show]
  before_action :sidebar_tags, only: %i[show]
  before_action :tag_videos, only: %i[show]
  before_action :current_user_voted_video_ids, only: %i[show]
  before_action :voted, only: %i[show]
  before_action :rematch_request_sent, only: %i[show]
  before_action :user_without_votes, only: %i[show]

  def show; end

  private

  def battle
    @battle ||= Battle::ObjectWithTitleAndMemberQuery.call(params[:id])
  end

  def sidebar_tags
    @sidebar_tags ||= get_sidebar_tags(70)
  end

  def tag_videos
    @tag_videos ||= battle.tag.videos.active.limit(10).includes(:user)
  end

  def current_user_voted_video_ids
    @current_user_voted_video_ids ||= current_user.votes.map(&:video_id) if current_user.present?
  end

  def voted
    @already_voted ||= CheckUserBattleVoteExistanceService.new(battle, request.ip, current_user).call
    @voted_member_name ||= @already_voted.last&.battle_member&.name if @already_voted.any?
  end

  def rematch_request_sent
    @rematch_request_sent ||= CheckUserBattleRematchRequestExistanceService.new(battle, request.ip, current_user).call
  end

  def user_without_votes
    @user_without_votes ||= CheckUserAnyBattleVoteExistanceService.new(battle, request.ip, current_user).call
  end

  def meta_title
    @meta_title = case action_name
                  when 'show'
                    [
                      "#{battle.title}, Flickbin Creator Battle"
                    ]
                  else
                    super
    end
  end
end
