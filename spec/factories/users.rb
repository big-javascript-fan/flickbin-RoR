# == Schema Information
#
# Table name: users
#
#  id                            :bigint(8)        not null, primary key
#  email                         :string           default(""), not null
#  encrypted_password            :string           default(""), not null
#  reset_password_token          :string
#  reset_password_sent_at        :datetime
#  remember_created_at           :datetime
#  confirmation_token            :string
#  confirmed_at                  :datetime
#  confirmation_sent_at          :datetime
#  unconfirmed_email             :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  channel_name                  :string
#  slug                          :string
#  channel_description           :text
#  avatar                        :string
#  rank                          :integer          default(0)
#  role                          :string           default("client")
#  fake_avatar_url               :string           default("")
#  allowed_to_send_notifications :boolean          default(TRUE)
#  receive_notification_emails   :boolean          default(TRUE)
#  receive_promotional_emails    :boolean          default(TRUE)
#

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
