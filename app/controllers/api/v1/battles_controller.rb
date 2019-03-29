class Api::V1::BattlesController < Api::V1::BaseController
  before_action :set_battle

  def update
    ip = @battle.vote_ips.find_by(ip: request.ip)
    if (@battle.vote_ips.where(ip: request.ip).any? && Time.now <= ip.updated_at + 1.day)
      render status: 409, json: {message: "You can vote once every 24 hours" }.to_json
    else
      ip.present? ? ip.update(updated_at: Time.now) : VoteIp.create(battle_id: @battle.id, ip: request.ip)
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