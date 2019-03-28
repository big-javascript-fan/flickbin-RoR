# == Schema Information
#
# Table name: videos
#
#  id                    :bigint(8)        not null, primary key
#  title                 :string
#  url                   :string
#  user_id               :integer
#  tag_id                :integer
#  rank                  :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string
#  cover                 :string
#  removed               :boolean          default(FALSE)
#  untagged              :boolean          default(FALSE)
#  source_id             :string
#  positive_votes_amount :integer          default(0)
#  negative_votes_amount :integer          default(0)
#  wasp_outreach         :boolean          default(FALSE)
#  twitter_handle        :string
#  wasp_post             :boolean          default(FALSE)
#  comments_count        :integer          default(0)
#  source                :string           default("")
#  kind_of               :string           default("")
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
