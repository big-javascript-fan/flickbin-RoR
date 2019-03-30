class FinishBattleService
  def initialize(battle_id)
    @battle = Battle.find(battle_id)
  end

  def call
    if @battle.first_member_voices > @battle.second_member_voices
     @battle.update(winner: @battle.first_member.name, status: 'finished')
    elsif @battle.first_member_voices < @battle.second_member_voices
      @battle.update(winner: @battle.second_member.name, status: 'finished')
    else
      @battle.update(winner: 'draw', status: 'finished')
    end
  end
end
