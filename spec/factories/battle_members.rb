# == Schema Information
#
# Table name: battle_members
#
#  id                   :bigint(8)        not null, primary key
#  name                 :string
#  photo                :string
#  twitter_account_name :string
#  youtube_channel_guid :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint(8)
#
# Indexes
#
#  index_battle_members_on_user_id  (user_id)
#

FactoryBot.define do
  factory :battle_member do
    youtube_channel_guid { "MyString" }
    twitter_account_name { "MyString" }
    photo { "MyString" }
    name { "MyString" }
  end
end
