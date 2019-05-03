# frozen_string_literal: true

class Notifications::WeeklyMailingService
  def call
    tags_with_vidoes = get_valid_tags_with_vidoes
    User.where.not(role: 'dummy').find_each do |user|
      ApplicationMailer.weekly_mailing(user, tags_with_vidoes).deliver_now
    end
  rescue StandardError => e
    ExceptionLogger.create(source: 'WeeklyMailingJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'WeeklyMailingJob#perform' })
  end

  private

  def get_valid_tags_with_vidoes
    counted_video_url = []
    counted_user_id = []
    number_of_valid_tags = 0
    tags = Tag.joins(:videos)
              .where(videos: { untagged: false, removed: false })
              .order('tags.rank ASC')
              .distinct

    tags.each_with_object({}) do |tag, tags_with_vidoes|
      break tags_with_vidoes if number_of_valid_tags == 3

      counted_video_url_for_tag = []
      counted_user_id_for_tag = []
      number_of_valid_videos_for_tag = 0

      tag.ranking_videos.each_with_object([]) do |video, videos|
        if counted_video_url.include?(video.url) || counted_video_url_for_tag.include?(video.url) ||
           counted_user_id.include?(video.user_id) || counted_user_id_for_tag.include?(video.user_id)
          next
        else
          videos << video
          counted_video_url_for_tag << video.url
          counted_user_id_for_tag << video.user_id
          number_of_valid_videos_for_tag += 1
        end

        next unless number_of_valid_videos_for_tag == 3

        tags_with_vidoes[tag] = videos
        number_of_valid_tags += 1
        counted_video_url |= counted_video_url_for_tag
        counted_user_id |= counted_user_id_for_tag
        break
      end
    end
  end
end
