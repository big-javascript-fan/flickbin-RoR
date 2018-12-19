class Notification < ApplicationRecord
  max_pages 5

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

  after_create :leave_only_15_unread_notifications

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def leave_only_15_unread_notifications
    byebug
  end
end
