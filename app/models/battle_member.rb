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

class BattleMember < ApplicationRecord
  attr_accessor :youtube_channel_url, :channel_avatar_url

  mount_uploader :channel_avatar, BattleMemberChannelAvatarUploader

  has_many :battles
  has_many :opponents, through: :battles
end
