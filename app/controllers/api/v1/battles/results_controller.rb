# frozen_string_literal: true

class Api::V1::Battles::ResultsController < Api::V1::BaseController
  def show
    @battle = Battle.find(params[:id])
    @current_user_unvoted = CheckUserAnyBattleVoteExistanceService.new(@battle, request.ip, current_user).call
    render json: {
      first_member_votes: @battle.first_member_votes,
      second_member_votes: @battle.second_member_votes,
      current_user_unvoted: @current_user_unvoted
    }.to_json
  end
end
