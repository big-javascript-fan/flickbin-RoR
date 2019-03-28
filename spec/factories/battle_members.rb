# == Schema Information
#
# Table name: battle_members
#
#  id                 :bigint(8)        not null, primary key
#  youtube_channel_id :string
#  twitter_account    :string
#  channel_avatar     :string
#  channel_title      :string
#  station_title      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :battle_member do
    youtube_channel_id { "MyString" }
    twitter_account { "MyString" }
    station { "MyString" }
    avatar { "MyString" }
    name { "MyString" }
  end
end
