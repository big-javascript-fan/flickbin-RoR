class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  has_many :videos, -> { order(rank: :asc) }, dependent: :destroy
  has_many :top_10_videos, -> { order(rank: :asc).limit(10) }, class_name: 'Video'
  has_many :users, through: :videos


  validates_presence_of :title
  validates_format_of   :title, with: AppConstants::TAG_TITLE_REGEXP,
                                message: 'You can use only letters & numbers'

  before_save :convert_to_lowercase_title
  after_create :set_init_rank

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end

  def set_init_rank
    self.update(rank: self.id)
  end

  def convert_to_lowercase_title
    self.title.downcase!
  end
end
