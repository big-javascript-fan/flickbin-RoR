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

FactoryBot.define do
  factory :battle do
    frist_member_id { 1 }
    second_member_id { 1 }
    final_date { "2019-03-12 15:35:44" }
  end
end
