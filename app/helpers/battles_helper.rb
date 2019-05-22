# frozen_string_literal: true

module BattlesHelper
  def battle_heading_title
    'CREATOR BATTLE'
  end

  def battle_final_date
    (@battle.final_date + 1.minute).to_formatted_s(:iso8601)
  end

  def battle_id
    @battle.id
  end

  def battles_twitter_account_name_for(current_member)
    @battle.try("#{current_member}_battles_twitter_account_name") || ''
  end

  def battles_voices_for(current_member)
    @battle.try("#{current_member}_battles_voices")
  end

  def battles_name_for(current_member)
    @battle.try("#{current_member}_battles_name")
  end

  def battles_photo_for(current_member)
    @battle.try("#{current_member}_battles_photo")
  end

  def battle_winner?(current_member)
    @battle.winner == battles_name_for(current_member)
  end

  def battle_live?
    @battle.status == 'live'
  end

  def battle_finished?
    @battle.status == 'finished'
  end

  def already_voted_any?
    @already_voted.any?
  end

  def battle_draw?
    @battle.winner == 'draw'
  end
end
