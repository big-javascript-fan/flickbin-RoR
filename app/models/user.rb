class User < ApplicationRecord
  extend FriendlyId
  friendly_id :channel_name, use: [:sequentially_slugged, :finders]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable

  mount_uploader :avatar, UserAvatarUploader

  has_many :videos, dependent: :destroy
  has_many :tags, through: :videos
  has_many :votes, dependent: :destroy, class_name: 'Vote', foreign_key: :voter_id
  has_many :voters, through: :votes
  has_many :comments, dependent: :destroy, class_name: 'Comment', foreign_key: :commentator_id

  validates_presence_of   :channel_name
  validates_uniqueness_of :channel_name, allow_blank: true
  validates_length_of :channel_description, maximum: AppConstants::MAX_CHANNEL_DESCRIPTION_LENGTH,
                                            allow_blank: true

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
