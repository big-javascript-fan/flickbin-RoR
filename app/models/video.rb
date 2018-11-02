class Video < ApplicationRecord
  attr_accessor :tag_name

  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  mount_uploader :cover, VideoCoverUploader

  belongs_to :user
  belongs_to :tag
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :url, presence: true, format: { with: AppConstants::YOUTUBE_URL_REGEXP }
  validates :title, presence: true
  validates_uniqueness_of :url, scope: :tag_id

  before_validation :upload_data_from_youtube_api, if: :will_save_change_to_url?
  after_create :set_init_rank

  scope :active, -> { where(removed: false) }
  scope :tagged, -> { where(untagged: false) }

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end

  def upload_data_from_youtube_api
    youtube_video_id = self.url[/\/watch\?v=([^&.]+)/, 1]
    return errors.add(:invalid_url, 'Video url invalid') if youtube_video_id.blank?

    youtube_video = Yt::Video.new id: youtube_video_id
    self.title = youtube_video.title
    self.youtube_id = youtube_video_id
    self.remote_cover_url = youtube_video.thumbnail_url
  rescue => e
    errors.add(:invalid_url, 'Video url invalid')
  end

  def votes_amount
    self.positive_votes_amount + self.negative_votes_amount
  end

  def set_init_rank
    self.update(rank: self.id)
  end

  def remaining_days
    AppConstants::LIFETIME_IN_DAYS_OF_TAGGED_VIDEO - ((Time.now - self.created_at) / 1.day).round
  end
end
