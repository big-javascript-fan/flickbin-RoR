class BattleMember < ApplicationRecord
  attr_accessor :youtube_channel_url, :channel_avatar_url

  mount_uploader :channel_avatar, BattleMemberChannelAvatarUploader

  has_many :battles
  has_many :opponents, through: :battles
end
