# == Schema Information
#
# Table name: battles
#
#  id                         :bigint(8)        not null, primary key
#  tag_id                     :integer
#  first_member_id            :integer
#  second_member_id           :integer
#  first_member_voices        :integer
#  second_member_voices       :integer
#  number_of_rematch_requests :integer
#  winner                     :string
#  status                     :string           default("live")
#  final_date                 :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class Battle < ApplicationRecord
  STATUSES = %w(live finished)

  belongs_to :tag
  belongs_to :first_member, class_name: 'BattleMember', foreign_key: :first_member_id
  belongs_to :second_member, class_name: 'BattleMember', foreign_key: :second_member_id

  validates_inclusion_of :status, in: STATUSES
  validates_presence_of  :status, :tag, :first_member, :second_member, :final_date
end
