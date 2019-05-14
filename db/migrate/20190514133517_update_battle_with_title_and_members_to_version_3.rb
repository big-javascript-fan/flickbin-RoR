class UpdateBattleWithTitleAndMembersToVersion3 < ActiveRecord::Migration[5.1]
  def change
    update_view :battle_with_title_and_members, version: 3, revert_to_version: 2
  end
end
