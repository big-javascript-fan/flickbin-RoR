class BattleMember < ApplicationRecord
  attr_accessor :youtube_channel_url

  has_many :battles
  has_many :opponents, through: :battles
end
