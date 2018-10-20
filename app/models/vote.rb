class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voter, class_name: 'User'

  validates_uniqueness_of :voter_id, scope: :user_id
end
