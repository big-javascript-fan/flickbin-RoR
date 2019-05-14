# frozen_string_literal: true
# == Schema Information
#
# Table name: battle_with_title_and_members
#
#  id                                          :bigint(8)        primary key
#  final_date                                  :datetime
#  first_members_battles_name                  :string
#  first_members_battles_photo                 :string
#  first_members_battles_twitter_account_name  :string
#  first_members_battles_voices                :bigint(8)
#  loser_members_battles_twitter_account_name  :string
#  loser_members_battles_voices                :bigint(8)
#  number_of_rematch_requests                  :integer
#  second_members_battles_name                 :string
#  second_members_battles_photo                :string
#  second_members_battles_twitter_account_name :string
#  second_members_battles_voices               :bigint(8)
#  slug                                        :string
#  status                                      :string
#  title                                       :text
#  winner                                      :string
#  winner_members_battles_photo                :string
#  winner_members_battles_twitter_account_name :string
#  winner_members_battles_voices               :bigint(8)
#  created_at                                  :datetime
#  updated_at                                  :datetime
#  first_member_id                             :integer
#  first_members_battles_id                    :bigint(8)
#  second_member_id                            :integer
#  second_members_battles_id                   :bigint(8)
#  tag_id                                      :integer
#  winner_members_battles_id                   :bigint(8)
#

class BattleWithTitleAndMember < ApplicationRecord
  self.primary_key = :id

  belongs_to :first_member, class_name: 'BattleMember', foreign_key: :first_member_id
  belongs_to :second_member, class_name: 'BattleMember', foreign_key: :second_member_id
  belongs_to :tag
  has_many :battle_votes, foreign_key: :battle_id
  has_many :rematch_requests, foreign_key: :battle_id

  mount_uploader :first_members_battles_photo, BattleMemberChannelAvatarUploader
  mount_uploader :second_members_battles_photo, BattleMemberChannelAvatarUploader
  mount_uploader :winner_members_battles_photo, BattleMemberChannelAvatarUploader

  def readonly?
    true
  end

  def winner_member
    return first_member if winner == first_members_battles_name
    return second_member if winner == second_members_battles_name
  end
end
