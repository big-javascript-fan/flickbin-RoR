# frozen_string_literal: true

# == Schema Information
#
# Table name: battle_votes
#
#  id               :bigint(8)        not null, primary key
#  ip               :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  battle_id        :bigint(8)
#  battle_member_id :bigint(8)
#  user_id          :bigint(8)
#
# Indexes
#
#  index_battle_votes_on_battle_id         (battle_id)
#  index_battle_votes_on_battle_member_id  (battle_member_id)
#  index_battle_votes_on_user_id           (user_id)
#

class BattleVote < ApplicationRecord
  belongs_to :battle
  belongs_to :user, optional: true
  belongs_to :battle_member

  validates :ip, presence: true
end
