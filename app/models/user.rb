class User < ApplicationRecord
  extend FriendlyId
  friendly_id :channel_name, use: [:sequentially_slugged, :finders]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable

  validates_presence_of   :channel_name
  validates_uniqueness_of :channel_name, allow_blank: true

  def should_generate_new_friendly_id?
    slug.blank? || channel_name_changed?
  end
end
