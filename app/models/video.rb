# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id                    :bigint(8)        not null, primary key
#  comments_count        :integer          default(0)
#  cover                 :string
#  duration              :integer
#  high_quality_cover    :boolean          default(FALSE)
#  kind_of               :string           default("")
#  length                :string
#  negative_votes_amount :integer          default(0)
#  positive_votes_amount :integer          default(0)
#  rank                  :integer
#  removed               :boolean          default(FALSE)
#  slug                  :string
#  source                :string           default("")
#  title                 :string
#  twitter_handle        :string
#  untagged              :boolean          default(FALSE)
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  source_id             :string
#  tag_id                :integer
#  user_id               :integer
#
# Indexes
#
#  index_videos_on_rank                (rank)
#  index_videos_on_slug                (slug) UNIQUE
#  index_videos_on_source_id           (source_id)
#  index_videos_on_tag_id              (tag_id)
#  index_videos_on_url_and_tag_id      (url,tag_id)
#  index_videos_on_user_id_and_tag_id  (user_id,tag_id)
#

class Video < ApplicationRecord
  attr_accessor :tag_name

  extend FriendlyId
  friendly_id :title, use: %i[sequentially_slugged finders]

  mount_uploader :cover, VideoCoverUploader

  SOURCES = %w[youtube facebook twitch daily_motion].freeze
  KINDS_OF = %w[video clip stream].freeze

  belongs_to :user
  belongs_to :tag
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :url, presence: true
  validates :title, presence: true
  validates_inclusion_of(
    :source,
    in: SOURCES
  )
  validates_inclusion_of(
    :kind_of,
    in: KINDS_OF
  )
  # validates_uniqueness_of(
  #   :source_id,
  #   scope: %i[tag_id source],
  #   conditions: -> { where(untagged: false, removed: false) }
  # )
  # validates_uniqueness_of(
  #   :source_id,
  #   conditions: -> { where(untagged: false, removed: false) }
  # )

  before_validation :add_extra_video_data, if: :will_save_change_to_url?
  after_create :set_init_rank
  after_save :recalculate_videos_rank, if: :saved_change_to_removed?
  after_create :send_message_in_broadcast_after_create
  after_save :send_message_in_broadcast_after_destroy, if: :saved_change_to_removed?

  scope :active, -> { where(removed: false) }
  scope :tagged, -> { where(untagged: false) }

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end

  def add_extra_video_data
    ExtraVideoDataService.new(self).call unless Rails.env.test?
  end

  def votes_amount
    votes_sum = positive_votes_amount + negative_votes_amount
    votes_sum.negative? ? 0 : votes_sum
  end

  def set_init_rank
    max_rank = Video.active.tagged.where(tag_id: tag.id).maximum(:rank) || 0
    update(rank: max_rank + 1)
  end

  def recalculate_videos_rank
    RecalculateVideosRankForSpecificTagJob.perform_later(tag)
  end

  def tagged?
    !untagged?
  end

  def not_removed?
    !removed?
  end

  def remaining_days
    AppConstants::LIFETIME_IN_DAYS_OF_TAGGED_VIDEO - ((Time.now - created_at) / 1.day).round
  end

  private

  def send_message_in_broadcast_after_create
    Broadcast::HomePageService.call(:create, video: self, user: user, tag: tag)
  end

  def send_message_in_broadcast_after_destroy
    Broadcast::HomePageService.call(:destroy, video: self)
  end
end
