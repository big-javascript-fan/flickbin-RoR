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
    @battle.vote_ips.where(where_params).any?
  end
end
