class Api::V1::Comments::IndexSerializer
  include ActionView::Helpers::DateHelper

  def initialize(comments)
    @comments = comments
  end

  def call
    Oj.dump(comments_to_hash(@comments))
  end

  private

  def comments_to_hash(comments)
    return [] if comments.blank?

    comments.map do |comment|
      {
        id:          comment.id,
        parent_id:   comment.parent_id,
        message:     comment.message,
        post_time:   time_ago_in_words(comment.created_at),
        commentator: commentator_to_hash(comment.commentator)
      }
    end
  end

  def commentsator_to_hash(user)
    {
      id:           user.id,
      channel_name: user.channel_name,
      avatar:       user.avatar.thumb_44x44.url
    }
  end
end
