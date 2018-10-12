class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  has_many :videos, -> { order(rank: :asc) }, dependent: :destroy
  has_many :top_10_videos, -> { order(rank: :asc).limit(10) }, class_name: 'Video'
  has_many :users, through: :videos


  validates_presence_of :title

  after_create :set_init_rank

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end

  def set_init_rank
    self.update(rank: self.id)
  end
end
