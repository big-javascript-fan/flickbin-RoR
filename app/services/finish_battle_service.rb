class FinishBattleService
  def initialize(battle_id)
    @battle = Battle.find(battle_id)
  end

  def call
    first_voices = @battle.battle_votes.where(battle_member_id: @battle.first_member.id).count
    second_voices = @battle.battle_votes.where(battle_member_id: @battle.second_member.id).count 
    if first_voices > second_voices
     @battle.update(winner: @battle.first_member.name, status: 'finished')
    elsif first_voices < second_voices
      @battle.update(winner: @battle.second_member.name, status: 'finished')
    else
      @battle.update(winner: 'draw', status: 'finished')
    end
  end
end
