class RecalculateVideosRankService
  def call
    Tag.find_each do |tag|
      rank = 1
      upvote_for_last_week = "votes.value = 1 AND votes.created_at BETWEEN '#{1.week.ago.to_s}' AND '#{Time.now}'"
      sorted_videos_for_tag = Video.active
                                   .tagged
                                   .where(tag_id: tag.id)
                                   .left_outer_joins(:votes)
                                   .group(:id)
                                   .order("SUM(CASE WHEN #{upvote_for_last_week} THEN 1 ELSE 0 END) DESC, videos.created_at DESC")


      sorted_videos_for_tag.each do |video|
        video.update_attribute(:rank, rank)
        rank += 1
      end
    end
  end
end
