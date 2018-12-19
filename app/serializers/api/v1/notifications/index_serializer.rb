class Api::V1::Notifications::IndexSerializer < Api::V1::BaseSerializer
  def initialize(notifications)
    @notifications = notifications
  end

  def call
    Oj.dump(
      notifications: notifications_to_hash(@notifications),
      total_unread_notifications: @notifications.unread.total_count,
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
      read: notification.read
    }

    case notification.category
    when 'comment_video', 'reply_video_comment'
      comment = Comment.find(notification.event_object['comment'])
      notification_hash.update(
        video: comment.video,
        commentator: comment.commentator,
        comment: comment
      )
    when 'top_1_contributor', 'top_3_contributors', 'top_5_contributors', 'top_10_contributors'
      tag = Tag.find(notification.event_object['tag'])
      notification_hash.update(tag: tag)
    when 'top_1_video_in_tag', 'top_10_videos_in_tag'
      video = Video.find(notification.event_object['video'])
      notification_hash.update(
        tag: video.tag,
        video: video
      )
    end

    notification_hash
  end
end
