# frozen_string_literal: true

# == Schema Information
#
# Table name: battle_with_title_and_members
#
#  id                                          :bigint(8)        primary key
#  custom_title                                :text
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

require 'rails_helper'

RSpec.describe BattleWithTitleAndMember, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
