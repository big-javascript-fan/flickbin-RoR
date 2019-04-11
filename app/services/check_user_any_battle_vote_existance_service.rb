class CheckUserAnyBattleVoteExistanceService
  def initialize(battle, ip, user)
    @battle = battle
    @user = user
    @ip = ip
  end
 
  def call
    where_params = {
      user: @user
    }
    where_params[:ip] = @ip if @user.blank?
    @battle.battle_votes.where(where_params).any? ? false : true
  end
 end