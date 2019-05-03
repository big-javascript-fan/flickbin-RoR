# frozen_string_literal: true

class Api::V1::Battles::RematchRequestsController < Api::V1::BaseController
  before_action :set_battle

  def create
    if @battle.live?
      render status: 409, json: { message: 'Rematch can be requested only for finished battle' }.to_json
    elsif CheckUserBattleRematchRequestExistanceService.new(@battle, request.ip, current_user).call
      render status: 409, json: { message: 'You can request rematch only once per battle' }.to_json
    else
      RematchRequest.create(battle: @battle, ip: request.ip, user: current_user)
      @battle.increment!(:number_of_rematch_requests)
      render status: 200, json: { message: 'OK' }.to_json
    end
  end

  private

  def set_battle
    @battle = Battle.find(params[:id])
  end
end
