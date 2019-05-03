# frozen_string_literal: true

class Notifications::AfterCommentService
  def initialize(comment_id, options = {})
    @comment = Comment.find(comment_id)
    @video = @comment.video
    @options = options
  end

  def call
    if @options[:is_reply_comment].present?
      Notification.create!(
        user_id: @comment.parent&.commentator&.id,
        category: 'reply_video_comment',
        event_object: { comment: @comment.id }
      )
      ApplicationMailer.after_reply_comment(@video, @comment).deliver_later
    else
      Notification.create!(
        user_id: @video.user_id,
        category: 'comment_video',
        event_object: { comment: @comment.id }
      )
      ApplicationMailer.after_comment(@video, @comment).deliver_later
    end
  end
end
