class User < ApplicationRecord
  extend FriendlyId
  friendly_id :channel_name, use: [:sequentially_slugged, :finders]

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
  has_many :top_15_notifications, -> { order(created_at: :desc).limit(15) }, class_name: 'Notification'

  validates_presence_of   :channel_name
  validates_uniqueness_of :channel_name, allow_blank: true
  validates_length_of     :channel_name, maximum: AppConstants::MAX_CHANNEL_NAME_LENGTH
  validates_length_of :channel_description, maximum: AppConstants::MAX_CHANNEL_DESCRIPTION_LENGTH,
                                            allow_blank: true
  validates_inclusion_of :role, in: ['client', 'sidekiq_manager', 'dummy']

  before_create :set_default_channel_decription

  def sidekiq_manager?
    self.role == 'sidekiq_manager'
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
