# == Schema Information
#
# Table name: battle_members
#
#  id                   :bigint(8)        not null, primary key
#  youtube_channel_guid :string
#  twitter_account_name :string
#  photo                :string
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint(8)
#

FactoryBot.define do
  factory :battle_member do
    youtube_channel_guid { "MyString" }
    twitter_account_name { "MyString" }
    photo { "MyString" }
    name { "MyString" }
  end
end
