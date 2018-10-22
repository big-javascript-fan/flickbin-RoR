class Comment < ApplicationRecord
  belongs_to :video
  belongs_to :commentator, class_name: 'User'
  belongs_to :parent, class_name: 'Comment', optional: true, inverse_of: :parent
  has_many :subcomments, class_name: 'Comment', foreign_key: :parent_id, inverse_of: :subcomments
end
