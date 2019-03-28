class FinishBattleService
  def initialize(battle_id)
    @battle = Battle.find(battle_id)
    @first_voices = @battle.first_member_voices
    @second_voices = @battle.second_member_voices
    @first_channel = @battle.first_member.channel_title
    @second_channel = @battle.second_member.channel_title
  end

  def call
    if @first_voices > @second_voices
     @battle.update_attributes(winner: @first_channel, status: 'finished')
    elsif @first_voices < @second_voices
      @battle.update_attributes(winner: @second_channel, status: 'finished')
    else 
      @battle.update_attributes(winner: 'dead heat', status: 'finished')
    end
  end
end