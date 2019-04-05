# == Schema Information
#
# Table name: battles
#
#  id                         :bigint(8)        not null, primary key
#  final_date                 :datetime
#  first_member_voices        :integer          default(0)
#  number_of_rematch_requests :integer          default(0)
#  second_member_voices       :integer          default(0)
#  slug                       :string
#  status                     :string           default("live")
#  winner                     :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  first_member_id            :integer
#  second_member_id           :integer
#  tag_id                     :integer
#  winner_id                  :bigint(8)
#
# Indexes
#
#  index_battles_on_slug    (slug) UNIQUE
#  index_battles_on_tag_id  (tag_id)
#

class Battle < ApplicationRecord
  extend FriendlyId

  friendly_id :custom_title, use: [:slugged, :finders]

  #FIXME rework to enum
  STATUSES = %w(live finished)

  scope :live, -> { where(status: 'live') }

  belongs_to :tag
  belongs_to :first_member, class_name: 'BattleMember', foreign_key: :first_member_id
  belongs_to :second_member, class_name: 'BattleMember', foreign_key: :second_member_id
  has_many   :vote_ips
  has_many   :rematch_requests

  validates_inclusion_of :status, in: STATUSES
  validates_presence_of  :status, :tag, :first_member, :second_member, :final_date

  def live?
    status == 'live'
  end

  def finished?
    status == 'finished'
  end

  def custom_title
    "#{first_member.name} vs #{second_member.name} #{id}"
  end

  def winner_member
    return first_member if winner == first_member.name
    return second_member if winner == second_member.name
  end

  def loser_member
    return second_member if winner == first_member.name
    return first_member  if winner == second_member.name
  end

  def winner_votes
    return first_member_voices if winner == first_member.name
    return second_member_voices if winner == second_member.name
  end

  def loser_votes
    return second_member_voices if winner == first_member.name
    return first_member_voices if winner == second_member.name
  end
end
