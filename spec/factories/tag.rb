FactoryBot.define do
  factory :tag do
    sequence(:title) { |n| "#{n}#{Faker::Lorem.word[0..10]}" }
  end
end
