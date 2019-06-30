# frozen_string_literal: true

class RecalculateTagsRankService
  def call
    rank = 1
    upvote_for_last_three_days = "votes.value = 1 AND votes.created_at BETWEEN '#{3.days.ago}' AND '#{Time.now}'"
    video_valid_for_ranking = 'videos.removed = false AND videos.untagged = false'
    order_expression = "
      SUM(CASE WHEN #{upvote_for_last_three_days} THEN 1 ELSE 0 END) +
      COUNT(CASE WHEN #{video_valid_for_ranking} THEN 1 ELSE null END) +
      COUNT('comments')
      DESC, tags.created_at DESC
    "
    sorted_tags = Tag.left_outer_joins(videos: %i[votes comments])
                     .group(:id)
                     .order(order_expression)

    sorted_tags.each do |tag|
      tag.update_attribute(:rank, rank)
      rank += 1
    end
  end
end
