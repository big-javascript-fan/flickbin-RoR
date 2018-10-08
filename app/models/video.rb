class Video < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :url, presence: true, format: { with: AppConstants::YOUTUBE_URL_REGEXP }
  validates :title, presence: true
  validates_uniqueness_of :url, scope: :tag_id
end
