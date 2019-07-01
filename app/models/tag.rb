# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id              :bigint(8)        not null, primary key
#  first_character :string           default("")
#  rank            :integer
#  slug            :string
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_tags_on_first_character  (first_character)
#  index_tags_on_rank             (rank)
#  index_tags_on_slug             (slug) UNIQUE
#  index_tags_on_title            (title)
#

class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[sequentially_slugged finders]

  has_many :videos, -> { order(rank: :asc, created_at: :desc) }, dependent: :destroy
  has_many :accounting_videos, -> { active.tagged }, class_name: 'Video'
  has_many :top_3_videos, -> { active.tagged.order(rank: :asc, positive_votes_amount: :desc, created_at: :desc).limit(3) }, class_name: 'Video'
  has_many :top_10_videos, -> { active.tagged.order(rank: :asc, positive_votes_amount: :desc, created_at: :desc).limit(10) }, class_name: 'Video'
  has_many :ranking_videos, -> { active.tagged.order(rank: :asc, positive_votes_amount: :desc, created_at: :desc) }, class_name: 'Video'
  has_many :users, through: :videos
  has_many :votes, through: :videos
  has_many :comments, through: :videos
  has_many :contribution_points, dependent: :destroy
  has_many :contributors, -> { where(videos: { removed: false, untagged: false }) }, through: :videos, source: :user

  validates_presence_of :title
  validates_length_of   :title, maximum: AppConstants::MAX_TAG_TITLE_LENGTH,
                                allow_blank: true
  validates_format_of   :title, with: AppConstants::TAG_TITLE_REGEXP,
                                message: 'You can use only letters & numbers'

  validates_uniqueness_of :title, case_sensitive: false

  before_save :convert_to_lowercase_title_and_set_first_character
  after_create :set_init_rank
  after_touch :save

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end

  def set_init_rank
    max_rank = Tag.maximum(:rank) || 0
    update(rank: max_rank + 1)
  end

  def convert_to_lowercase_title_and_set_first_character
    self.title = title.downcase
    self.first_character = title.first
  end
end
