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
        case rank
        when 1
          top_1_video_in_tag_notification_handler(video)
        when 10
          top_10_videos_in_tag_notification_handler(video)
        end

        video.update_attribute(:rank, rank)
        rank += 1
      end
    end
  end

  private

  def top_1_video_in_tag_notification_handler(video)
    notification = Notification.create!(
      user_id: video.user_id,
      category: 'top_1_video_in_tag',
      event_object: { video: video.id }
    )

    ApplicationMailer.top_1_video_in_tag(video).deliver_later
  end

  def top_10_videos_in_tag_notification_handler(video)
    notification = Notification.create!(
      user_id: video.user_id,
      category: 'top_10_videos_in_tag',
      event_object: { video: video.id }
    )

    ApplicationMailer.top_10_videos_in_tag(video).deliver_later
  end
end
