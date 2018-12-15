class Notification < ApplicationRecord
  belongs_to :user

  CATEGORIES = [
    :comment,
    :reply_comment,
    :top_1_contributor,
    :top_3_contributors,
    :top_5_contributors,
    :top_10_contributors,
    :top_1_in_tag,
    :top_10_in_tag
  ]

  validates_inclusion_of :category, in: CATEGORIES
end
