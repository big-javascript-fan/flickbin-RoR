# frozen_string_literal: true

class CheckUserBattleRematchRequestExistanceService
  def initialize(battle, ip, user)
    @battle = battle
    @user = user
    @ip = ip
  end

  def call
    where_params = {
      user: @user
    }
    # Anton Tkachov. If user is not authenticated, that the only one check I see
    # so far is IP address
    where_params[:ip] = @ip if @user.blank?
    @battle.rematch_requests.where(where_params).any?
  end
end
