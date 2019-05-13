# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                            :bigint(8)        not null, primary key
#  allowed_to_send_notifications :boolean          default(TRUE)
#  avatar                        :string
#  channel_description           :text
#  channel_name                  :string
#  confirmation_sent_at          :datetime
#  confirmation_token            :string
#  confirmed_at                  :datetime
#  email                         :string           default(""), not null
#  encrypted_password            :string           default(""), not null
#  fake_avatar_url               :string           default("")
#  rank                          :integer          default(0)
#  receive_notification_emails   :boolean          default(TRUE)
#  receive_promotional_emails    :boolean          default(TRUE)
#  remember_created_at           :datetime
#  reset_password_sent_at        :datetime
#  reset_password_token          :string
#  role                          :string           default("client")
#  slug                          :string
#  unconfirmed_email             :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_users_on_channel_name          (channel_name) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
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
    sequence(:email) { |_n| 'rspec@example.com' }
    password { 'password' }
    channel_name { 'Rspec tester' }
    channel_description { 'Channel for rpsec tests' }
    confirmed_at { Time.now }
  end
end
