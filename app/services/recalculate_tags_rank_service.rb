class RecalculateTagsRankService
  def call
    rank = 1
    upvote_for_last_12_hours = "votes.value = 1 AND votes.created_at BETWEEN '#{12.hours.ago.to_s}' AND '#{Time.now}'"
    sorted_tags = Tag.left_outer_joins(videos: :votes)
                     .where(videos: { removed: false, untagged: false })
                     .group(:id)
                     .order("SUM(CASE WHEN #{upvote_for_last_12_hours} THEN 1 ELSE 0 END) + COUNT(videos) DESC, tags.created_at DESC")

    sorted_tags.each do |tag|
      tag.update_attribute(:rank, rank)
      rank += 1
    end
  end
end
