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

FactoryBot.define do
  factory :battle do
    frist_member_id { 1 }
    second_member_id { 1 }
    final_date { "2019-03-12 15:35:44" }
  end
end
