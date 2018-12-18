class Notification < ApplicationRecord
  belongs_to :user

  CATEGORIES = [
    'comment_video',
    'reply_video_comment',
    'top_1_contributor',
    'top_3_contributors',
    'top_5_contributors',
    'top_10_contributors',
    'top_1_video_in_tag',
    'top_10_videos_in_tag'
  ]

  validates_inclusion_of :category, in: CATEGORIES

  scope :not_read, -> { where(read: false) }
  scope :read, -> { where(read: true) }
end
