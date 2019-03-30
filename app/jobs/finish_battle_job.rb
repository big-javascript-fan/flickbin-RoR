class FinishBattleJob < ApplicationJob
  queue_as :finish_battle

  def perform(battle_id)
    FinishBattleService.new(battle_id).call
  end
end