class Tag < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :users, through: :videos

  validates_presence_of :title
end
