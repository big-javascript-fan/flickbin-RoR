class CreateBattleMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :battle_members do |t|
      t.string :youtube_channel_id
      t.string :twitter_account
      t.string :channel_avatar
      t.string :channel_title
      t.string :station_title

      t.timestamps
    end
  end
end
