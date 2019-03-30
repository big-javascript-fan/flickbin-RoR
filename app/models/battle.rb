# == Schema Information
#
# Table name: battles
#
#  id                         :bigint(8)        not null, primary key
#  final_date                 :datetime
#  first_member_voices        :integer          default(0)
#  number_of_rematch_requests :integer          default(0)
#  second_member_voices       :integer          default(0)
#  status                     :string           default("live")
#  winner                     :string           default("")
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  first_member_id            :integer
#  second_member_id           :integer
#  tag_id                     :integer
#
# Indexes
#
#  index_battles_on_tag_id  (tag_id)
#

class Battle < ApplicationRecord
  STATUSES = %w(live finished)

  belongs_to :tag
  belongs_to :first_member, class_name: 'BattleMember', foreign_key: :first_member_id
  belongs_to :second_member, class_name: 'BattleMember', foreign_key: :second_member_id
  has_many   :vote_ips

  validates_inclusion_of :status, in: STATUSES
  validates_presence_of  :status, :tag, :first_member, :second_member, :final_date

  after_create :set_finish_battle_job

  def set_finish_battle_job
    duration = self.final_date - Time.now
    FinishBattleJob.set(wait: duration).perform_later(self.id)
  end
end
