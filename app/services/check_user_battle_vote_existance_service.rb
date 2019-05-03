# frozen_string_literal: true

class CheckUserBattleVoteExistanceService
  def initialize(battle, ip, user)
    @battle = battle
    @user = user
    @ip = ip
  end

  def call
    where_params = {
      user: @user,
      created_at: (Time.now - 1.day)...Time.now
    }
    # Anton Tkachov. If user is not authenticated, that the only one check I see
    # so far is IP address
    where_params[:ip] = @ip if @user.blank?
    @battle.battle_votes.where(where_params)
  end
end
