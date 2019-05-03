# frozen_string_literal: true

class RecalculateVideosRankService
  def call
    Tag.find_each do |tag|
      rank = 1
      upvote_for_last_week = "votes.value = 1 AND votes.created_at BETWEEN '#{3.days.ago}' AND '#{Time.now}'"
      sorted_videos_for_tag = Video.active
                                   .tagged
                                   .where(tag_id: tag.id)
                                   .left_outer_joins(:votes)
                                   .group(:id)
                                   .order("SUM(CASE WHEN #{upvote_for_last_week} THEN 1 ELSE 0 END) DESC, videos.created_at DESC")

      sorted_videos_for_tag.each do |video|
        # if rank == 1
        #   top_1_video_in_tag_notification_handler(video)
        # elsif (2..10).include?(rank) && sorted_videos_for_tag.size > 10
        #   top_10_videos_in_tag_notification_handler(video)
        # end

        video.update_attribute(:rank, rank)
        rank += 1
      end
    end
  end

  private

  def top_1_video_in_tag_notification_handler(video)
    return unless allowed_to_create_new_notification?(video.user, 'top_1_video_in_tag')

    notification = Notification.create!(
      user_id: video.user_id,
      category: 'top_1_video_in_tag',
      event_object: { video: video.id }
    )

    ApplicationMailer.top_1_video_in_tag(video).deliver_now
  end

  def top_10_videos_in_tag_notification_handler(video)
    return unless allowed_to_create_new_notification?(video.user, 'top_10_videos_in_tag')

    notification = Notification.create!(
      user_id: video.user_id,
      category: 'top_10_videos_in_tag',
      event_object: { video: video.id }
    )

    ApplicationMailer.top_10_videos_in_tag(video).deliver_now
  end

  def allowed_to_create_new_notification?(user, category)
    not_outdated_notifications_in_category = user.notifications
                                                 .where(category: category)
                                                 .where("notifications.created_at BETWEEN '#{1.week.ago}' AND '#{Time.now}'")

    user.role == 'dummy' || not_outdated_notifications_in_category.present? ? false : true
  end
end
