# == Schema Information
#
# Table name: vote_ips
#
#  id         :bigint(8)        not null, primary key
#  ip         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  battle_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_vote_ips_on_battle_id  (battle_id)
#  index_vote_ips_on_user_id    (user_id)
#

class BattleVote < ApplicationRecord
  belongs_to :battle
  belongs_to :user, optional: true
  belongs_to :battle_member

  validates :ip, presence: true
end
