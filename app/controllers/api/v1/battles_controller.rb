class Api::V1::BattlesController < Api::V1::BaseController
  before_action :set_battle
  before_action :set_voices
  def index 
    # render json: Api::V1::Battles::IndexSerializer.new(@battle).call
    render json: [@voices1, @voices2]
  end

  def update
    if vote_ip_present?(request.ip, @battle.vote_ips)
      render json: "You can vote once every 24 hours".to_json
    else
      VoteIp.create(params[battle_id: @battle.id, ip: request.ip])
      @battle.increment!(:first_member_voices) if params[:value1] 
      @battle.increment!(:second_member_voices) if params[:value2]
      render json: [@voices1, @voices2]
    end
  end

  private 

  def vote_ip_present?(ip, vote_ips)
    vote_ips.each {|vip| return true if vip.ip == ip}
  end

  def set_battle 
    @battle = Battle.last
  end

  def set_voices 
    @voices1 = @battle.first_member_voices.to_json
    @voices2 = @battle.second_member_voices.to_json
  end
end