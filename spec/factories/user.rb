FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    password { 'password' }
    sequence(:channel_name) { |n| "#{n}#{Faker::Name.name}" }
    channel_description { Faker::Lorem.sentence }
    confirmed_at { Time.now }
  end

  factory :rspec_user do
    sequence(:email) { |n| "rspec@example.com" }
    password { 'password' }
    channel_name { 'Rspec tester' }
    channel_description { 'Channel for rpsec tests' }
    confirmed_at { Time.now }
  end


end
