class UpdateBattleWithTitleAndMembersToVersion2 < ActiveRecord::Migration[5.1]
  def change
    update_view :battle_with_title_and_members, version: 2, revert_to_version: 1
  end
end
