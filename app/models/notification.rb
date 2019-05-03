# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id           :bigint(8)        not null, primary key
#  category     :string
#  event_object :json
#  read         :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

class Notification < ApplicationRecord
  belongs_to :user

  CATEGORIES = %w[
    comment_video
    reply_video_comment
    top_1_contributor
    top_3_contributors
    top_5_contributors
    top_10_contributors
    kicked_out_of_top_contributor
    top_1_video_in_tag
    top_10_videos_in_tag
  ].freeze

  validates_inclusion_of :category, in: CATEGORIES

  after_create :leave_only_15_unread_notifications

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def leave_only_15_unread_notifications
    unread_notifications = user.notifications.unread.order(created_at: :desc)
    obsolete_notifications = unread_notifications - unread_notifications.first(15)
    if obsolete_notifications.present?
      obsolete_notifications.each do |obsolete_notificatio|
        obsolete_notificatio.update(read: true)
      end
    end
  end
end
