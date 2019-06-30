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

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :channel_name, use: %i[sequentially_slugged finders]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable

  mount_uploader :avatar, UserAvatarUploader

  has_many :videos, dependent: :destroy
  has_many :accounting_videos, -> { active.tagged }, class_name: 'Video'
  has_many :tags, through: :videos
  has_many :votes, dependent: :destroy, class_name: 'Vote', foreign_key: :voter_id
  has_many :voters, through: :votes
  has_many :comments, dependent: :destroy, class_name: 'Comment', foreign_key: :commentator_id
  has_many :contribution_points, dependent: :destroy
  has_many :contributed_tags, through: :contribution_points, source: :tag
  has_many :notifications, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :top_15_notifications, -> { order(created_at: :desc).limit(15) }, class_name: 'Notification'
  has_many :rematch_requests

  has_and_belongs_to_many(
    :followers,
    association_foreign_key: :follower_id,
    uniq: true,
    class_name: 'User'
  )

  validates_presence_of   :channel_name
  validates_uniqueness_of :channel_name, allow_blank: true
  validates_length_of     :channel_name, maximum: AppConstants::MAX_CHANNEL_NAME_LENGTH
  validates_length_of :channel_description, maximum: AppConstants::MAX_CHANNEL_DESCRIPTION_LENGTH,
                                            allow_blank: true
  validates_inclusion_of :role, in: %w[client sidekiq_manager dummy]

  before_create :set_default_channel_decription

  def sidekiq_manager?
    role == 'sidekiq_manager'
  end

  def set_default_channel_decription
    self.channel_description = 'This is a station description.'
  end

  def should_generate_new_friendly_id?
    slug.blank? || channel_name_changed?
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
