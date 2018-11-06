class RecalculateTagsRankService
  def call
    rank = 1
    upvote_for_last_12_hours = "votes.value = 1 AND votes.created_at BETWEEN '#{12.hours.ago.to_s}' AND '#{Time.now}'"
    video_valid_for_ranking = "videos.removed = false AND videos.untagged = false"
    order_expression = "
      SUM(
        CASE WHEN #{upvote_for_last_12_hours} THEN 1 ELSE 0 END) +
        COUNT(CASE WHEN #{video_valid_for_ranking} THEN 1 ELSE null END
      ) DESC, tags.created_at DESC
    "
    sorted_tags = Tag.left_outer_joins(videos: :votes)
                     .group(:id)
                     .order(order_expression)

    sorted_tags.each do |tag|
      tag.update_attribute(:rank, rank)
      rank += 1
    end
  end
end
