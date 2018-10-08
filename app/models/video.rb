class Video < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  belongs_to :user
  belongs_to :tag

  validates :url, presence: true, format: { with: AppConstants::YOUTUBE_URL_REGEXP }
  validates :title, presence: true
  validates_uniqueness_of :url, scope: :tag_id

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
