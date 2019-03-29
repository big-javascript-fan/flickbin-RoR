# == Schema Information
#
# Table name: battles
#
#  id                         :bigint(8)        not null, primary key
#  final_date                 :datetime
#  first_member_voices        :integer
#  number_of_rematch_requests :integer
#  second_member_voices       :integer
#  status                     :string           default("live")
#  winner                     :string
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

  validates_inclusion_of :status, in: STATUSES
  validates_presence_of  :status, :tag, :first_member, :second_member, :final_date
end
