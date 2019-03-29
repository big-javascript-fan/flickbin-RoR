class Api::V1::BattlesController < Api::V1::BaseController
  before_action :set_battle
  before_action :set_voices

  def update
    if vote_ip_present?(request.ip, @battle.vote_ips)
      render json: { status: 409, message: "You can vote once every 24 hours"}.to_json
    else
      ip = VoteIp.create(battle_id: @battle.id, ip: request.ip)
      @battle.increment!(:first_member_voices) if params[:value1] 
      @battle.increment!(:second_member_voices) if params[:value2]
      render json: { status: 200, message: 'OK'}.to_json
    end
  end

  private 

  def vote_ip_present?(ip, vote_ips)
    i = 0
    while i <= vote_ips.length
      puts i
      return true if vote_ips[i]&.ip == ip
      i += 1
    end
  end

  def set_battle 
    @battle = Battle.find(params[:id])
  end

  def set_voices 
    @voices1 = @battle.first_member_voices.to_json
    @voices2 = @battle.second_member_voices.to_json
  end
end