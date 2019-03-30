# == Schema Information
#
# Table name: vote_ips
#
#  id         :bigint(8)        not null, primary key
#  ip         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  battle_id  :bigint(8)
#
# Indexes
#
#  index_vote_ips_on_battle_id  (battle_id)
#

class VoteIp < ApplicationRecord
  belongs_to :battle
end
