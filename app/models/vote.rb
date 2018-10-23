class Vote < ApplicationRecord
  belongs_to :video
  belongs_to :voter, class_name: 'User'

  validates_uniqueness_of :voter_id, scope: :video_id
  validates_inclusion_of :value, in: [-1, 1]
end
