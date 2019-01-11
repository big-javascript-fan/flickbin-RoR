class Notifications::AfterReplyCommentJob
  def perform(comment_id)
    Notifications::AfterReplyCommentService.new(comment_id).call
  end
end
