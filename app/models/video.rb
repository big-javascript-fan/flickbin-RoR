class Video < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  mount_uploader :cover, VideoCoverUploader

  belongs_to :user
  belongs_to :tag

  validates :url, presence: true, format: { with: AppConstants::YOUTUBE_URL_REGEXP }
  validates :title, presence: true
  validates_uniqueness_of :url, scope: :tag_id

  before_validation :upload_video_cover, if: :will_save_change_to_url?
  after_create :set_init_rank

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def upload_video_cover
    youtube_video_id = self.url[/\/watch\?v=([^&.]+)/, 1]
    return errors.add(:invalid_url, 'Video url invalid') if youtube_video_id.blank?

    youtube_video = Yt::Video.new id: youtube_video_id
    self.title = youtube_video.title
    self.remote_cover_url = youtube_video.thumbnail_url
  rescue => e
    errors.add(:invalid_url, 'Video url invalid')
  end

  def set_init_rank
    self.update(rank: self.id)
  end

  def remaining_days
    AppConstants::LIFETIME_IN_DAYS_OF_TAGGED_VIDEO - ((Time.now - self.created_at) / 1.day).round
  end
end
