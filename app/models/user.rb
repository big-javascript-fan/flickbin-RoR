class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates_presence_of   :channel_name
  validates_uniqueness_of :channel_name, allow_blank: true
end
