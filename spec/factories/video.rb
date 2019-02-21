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
