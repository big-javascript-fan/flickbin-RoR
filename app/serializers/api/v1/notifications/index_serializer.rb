class Api::V1::Notifications::IndexSerializer < Api::V1::BaseSerializer
  def initialize(notifications)
    @notifications = notifications
  end

  def call
    Oj.dump(
      notifications: notifications_to_hash(@notifications),
      total_pages: @notifications.total_pages
    )
  end

  private

  def notifications_to_hash(notifications)
    return [] if notifications.blank?

    notifications.map do |notification|
      notification_to_hash(notification)
    end
  end

  def notification_to_hash(notification)
    notification_hash = {
      id:           notification.id,
      category:     notification.category,
      event_object: notification.event_object,
    }

    case notification.category
    when 'comment_video', 'reply_video_comment'
      comment = Comment.find(notification.event_object['comment'])
      notification_hash.update(comment_message: comment.message)
    end

    notification_hash
  end
end
