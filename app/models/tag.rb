class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:sequentially_slugged, :finders]

  has_many :videos, dependent: :destroy
  has_many :users, through: :videos

  validates_presence_of :title

  after_create :set_init_rank

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def set_init_rank
    self.update(rank: self.id)
  end
end
