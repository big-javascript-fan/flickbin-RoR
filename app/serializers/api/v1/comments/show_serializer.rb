# frozen_string_literal: true

class Api::V1::Comments::ShowSerializer
  include ActionView::Helpers::DateHelper

  def initialize(comment)
    @comment = comment
  end

  def call
    Oj.dump(comment_to_hash(@comment))
  end

  private

  def comment_to_hash(comment)
    {
      id: comment.id,
      parent_id: comment.parent_id,
      message: comment.message,
      post_time: time_ago_in_words(comment.created_at),
      commentator: commentator_to_hash(comment.commentator)
    }
  end

  def commentator_to_hash(user)
    {
      id: user.id,
      channel_name: user.channel_name,
      channel_slug: user.slug,
      avatar: user.avatar.thumb_44x44.url
    }
  end
end
