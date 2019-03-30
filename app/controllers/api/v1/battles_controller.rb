class Api::V1::BattlesController < Api::V1::BaseController
  before_action :set_battle

  def update
  if @battle.vote_ips.where(ip: request.ip, created_at: (Time.now - 1.day)...Time.now).any?
      render status: 409, json: {message: "You can vote once every 24 hours" }.to_json
    else
      VoteIp.create(battle_id: @battle.id, ip: request.ip)
      @battle.increment!(:first_member_voices) if params[:value1] 
      @battle.increment!(:second_member_voices) if params[:value2]
      render status: 200, json: {message: "OK" }.to_json
    end
  end

  private

  def set_battle
    @battle = Battle.find(params[:id])
  end
end