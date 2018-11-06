class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  has_many :videos, -> { order(rank: :asc, created_at: :desc) }, dependent: :destroy
  has_many :top_10_videos, -> { active.tagged.order(rank: :asc, created_at: :desc).limit(10) }, class_name: 'Video'
  has_many :users, through: :videos
  has_many :votes, through: :videos

  validates_presence_of :title
  validates_length_of   :title, maximum: AppConstants::MAX_TAG_TITLE_LENGTH,
                                allow_blank: true
  validates_format_of   :title, with: AppConstants::TAG_TITLE_REGEXP,
                                message: 'You can use only letters & numbers'

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
    self.update(rank: max_rank + 1)
  end

  def convert_to_lowercase_title_and_set_first_character
    self.title.downcase!
    self.first_character = self.title.first
  end
end
