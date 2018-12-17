class Notifications::AfterCommentService
  def initialize(comment_id, options = {})
    @comment = Comment.find(comment_id)
    @video = @comment.video
    @options = options
  end

  def call
    save_notification
    if @options[:is_reply_comment].present?.present?
      ApplicationMailer.after_reply_comment(@video, @comment).deliver_later
    else
      ApplicationMailer.after_comment(@video, @comment).deliver_later
    end
  end

  private

  def save_notification
    Notification.create!(
      user_id: @video.user_id,
      message: @comment.message,
      category: :after_comment,
      event_object: { comment: @comment.id }
    )
  end
end
