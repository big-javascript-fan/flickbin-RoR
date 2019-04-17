class SimplifyBattleMembersAccordingToTheDocumentation < ActiveRecord::Migration[5.1]
  def change
    change_table :battle_members do |t|
      t.rename :youtube_channel_id, :youtube_channel_guid
      t.rename :twitter_account, :twitter_account_name
      t.rename :channel_avatar, :photo
      t.rename :channel_title, :name

      t.references :user

      t.remove :station_title
    end
  end
end
