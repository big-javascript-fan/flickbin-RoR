class CreateBattleWithTitleAndMembers < ActiveRecord::Migration[5.1]
  def change
    create_view :battle_with_title_and_members, materialized: false
  end
end
