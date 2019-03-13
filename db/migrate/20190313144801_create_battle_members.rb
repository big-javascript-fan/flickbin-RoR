class CreateBattleMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :battle_members do |t|
      t.string :youtube_channel_id
      t.string :twitter_account
      t.string :station
      t.string :avatar
      t.string :name

      t.timestamps
    end
  end
end
