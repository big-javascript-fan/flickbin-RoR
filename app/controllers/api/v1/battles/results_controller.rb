class Api::V1::Battles::ResultsController < Api::V1::BaseController
  def show
    @battle = Battle.find(params[:id])
    render json: {
      first_member_votes: @battle.first_member_votes,
      second_member_votes: @battle.second_member_votes
    }.to_json
  end
end
