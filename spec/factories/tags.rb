# == Schema Information
#
# Table name: tags
#
#  id              :bigint(8)        not null, primary key
#  title           :string
#  rank            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#  first_character :string           default("")
#  wasp_post       :boolean          default(FALSE)
#

FactoryBot.define do
  factory :tag do
    sequence(:title) { |n| "#{n}#{Faker::Lorem.word[0..10]}" }
  end
end
