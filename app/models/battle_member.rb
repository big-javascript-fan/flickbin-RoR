# == Schema Information
#
# Table name: battle_members
#
#  id                 :bigint(8)        not null, primary key
#  youtube_channel_guid :string
#  twitter_account_name    :string
#  photo     :string
#  name      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class BattleMember < ApplicationRecord
  attr_accessor :youtube_channel_url, :photo_url

  validates :twitter_account_name, :photo, :name, :youtube_channel_guid, presence: true

  mount_uploader :photo, BattleMemberChannelAvatarUploader

  has_many :battles
  has_many :opponents, through: :battles
end
