# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                    :bigint(8)        not null, primary key
#  comments_count        :integer          default(0)
#  cover                 :string
#  duration              :integer
#  high_quality_cover    :boolean          default(FALSE)
#  kind_of               :string           default("")
#  length                :string
#  negative_votes_amount :integer          default(0)
#  positive_votes_amount :integer          default(0)
#  rank                  :integer
#  removed               :boolean          default(FALSE)
#  slug                  :string
#  source                :string           default("")
#  title                 :string
#  twitter_handle        :string
#  untagged              :boolean          default(FALSE)
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  source_id             :string
#  tag_id                :integer
#  user_id               :integer
#
# Indexes
#
#  index_videos_on_rank                (rank)
#  index_videos_on_slug                (slug) UNIQUE
#  index_videos_on_source_id           (source_id)
#  index_videos_on_tag_id              (tag_id)
#  index_videos_on_url_and_tag_id      (url,tag_id)
#  index_videos_on_user_id_and_tag_id  (user_id,tag_id)
#

FactoryBot.define do
  factory :video do
    association :user
    association :tag
    title { Faker::Hacker.say_something_smart }
    url { Faker::Internet.url('youtube.com') }
    source_id { Faker::Internet.password }
    source { Video::SOURCES.sample }
    kind_of { Video::KINDS_OF.sample }
    cover { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'video_cover.jpg')) }
  end
end
