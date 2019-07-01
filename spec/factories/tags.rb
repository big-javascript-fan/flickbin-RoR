# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id              :bigint(8)        not null, primary key
#  first_character :string           default("")
#  rank            :integer
#  slug            :string
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_tags_on_first_character  (first_character)
#  index_tags_on_rank             (rank)
#  index_tags_on_slug             (slug) UNIQUE
#  index_tags_on_title            (title)
#

FactoryBot.define do
  factory :tag do
    sequence(:title) { |n| "#{n}#{Faker::Lorem.word[0..10]}" }
  end
end
