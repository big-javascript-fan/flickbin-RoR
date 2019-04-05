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

class BattleMember < ApplicationRecord
  attr_accessor :youtube_channel_url, :photo_url

  validates :twitter_account_name, :photo, :name, :youtube_channel_guid, presence: true

  mount_uploader :photo, BattleMemberChannelAvatarUploader

  belongs_to :user
  has_many :opponents, through: :battles
  has_many :battle_votes
end
