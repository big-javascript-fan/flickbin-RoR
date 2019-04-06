class BattleResults
  def show
    @battle = Battle.find(params[:ip]) 
    render json: { @battle.first_member_votes.to_json. @battle.second_member_votes.to_json }
  end 
end