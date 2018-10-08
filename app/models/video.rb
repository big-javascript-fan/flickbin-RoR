class Video < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  mount_uploader :cover, VideoCoverUploader

  belongs_to :user
  belongs_to :tag

  validates :url, presence: true, format: { with: AppConstants::YOUTUBE_URL_REGEXP }
  validates :title, presence: true
  validates_uniqueness_of :url, scope: :tag_id

  after_validation :upload_video_cover

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def upload_video_cover
    youtube_video_id = self.url.split('watch?v=').last
    cover_url = "https://img.youtube.com/vi/#{youtube_video_id}/1.jpg"
    self.remote_cover_url = cover_url
  end
end
