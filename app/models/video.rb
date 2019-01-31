class Video < ApplicationRecord
  attr_accessor :tag_name

  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  mount_uploader :cover, VideoCoverUploader

  SOURCES = %w(youtube facebook twitch daily_motion)
  KINDS_OF = %w(video clip stream)

  belongs_to :user
  belongs_to :tag
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :url, presence: true
  validates :title, presence: true
  validates_inclusion_of :source, in: SOURCES
  validates_inclusion_of :kind_of, in: KINDS_OF
  validates_uniqueness_of :source_id, scope: [:tag_id, :source], conditions: -> { where(untagged: false, removed: false) }

  before_validation :add_extra_video_data, if: :will_save_change_to_url?
  after_create :set_init_rank
  after_save :recalculate_videos_rank, if: :saved_change_to_removed?

  scope :active, -> { where(removed: false) }
  scope :tagged, -> { where(untagged: false) }

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end

  def add_extra_video_data
    ExtraVideoDataService.new(self).call
  end

  def votes_amount
    votes_sum = self.positive_votes_amount + self.negative_votes_amount
    votes_sum.negative? ? 0 : votes_sum
  end

  def set_init_rank
    max_rank = Video.active.tagged.where(tag_id: self.tag.id).maximum(:rank) || 0
    self.update(rank: max_rank + 1)
  end

  def recalculate_videos_rank
    RecalculateVideosRankForSpecificTagJob.perform_later(self.tag)
  end

  def tagged?
    !untagged?
  end

  def not_removed?
    !removed?
  end

  def remaining_days
    AppConstants::LIFETIME_IN_DAYS_OF_TAGGED_VIDEO - ((Time.now - self.created_at) / 1.day).round
  end
end
