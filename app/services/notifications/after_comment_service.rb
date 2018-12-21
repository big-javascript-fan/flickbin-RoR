class Notifications::AfterCommentService
  def initialize(comment_id, options = {})
    @comment = Comment.find(comment_id)
    @video = @comment.video
    @options = options
  end

  def call
    return in not_outdated_notifications_in_category

    if @options[:is_reply_comment].present?
      save_notification('reply_video_comment')
      ApplicationMailer.after_reply_comment(@video, @comment).deliver_later
    else
      save_notification('comment_video')
      ApplicationMailer.after_comment(@video, @comment).deliver_later
    end
  end

  private

  def save_notification(category)
    Notification.create!(
      user_id: @video.user_id,
      category: category,
      event_object: { comment: @comment.id }
    )
  end
end
