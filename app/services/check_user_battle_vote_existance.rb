class CheckUserBattleVoteExistance
  def initialize(battle, ip, user)
    @battle = battle
    @user = user
    @ip = ip
  end

  def call
    @battle.vote_ips.where(ip: @ip,
                           user: @user,
                           created_at: (Time.now - 1.day)...Time.now).any?
  end
end
