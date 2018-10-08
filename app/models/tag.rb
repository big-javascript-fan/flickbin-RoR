class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  has_many :videos, dependent: :destroy
  has_many :users, through: :videos

  validates_presence_of :title

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
