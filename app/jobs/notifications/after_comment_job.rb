class Notifications::AfterCommentJob
  def perform(comment_id)
    Notifications::AfterCommentService.new(comment_id).call
  end
end
