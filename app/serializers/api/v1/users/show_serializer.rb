# frozen_string_literal: true

class Api::V1::Users::ShowSerializer < Api::V1::BaseSerializer
  include ActionView::Helpers::DateHelper

  def initialize(sidebar_tags, videos, options = {})
    @options = options
    @sidebar_tags = sidebar_tags
    @videos = videos
  end

  def call
    Oj.dump(
      sidebar_tags: sidebar_tags_to_hash(@sidebar_tags),
      station_videos: videos_to_hash(@videos),
      current_user_station: @options[:current_user_station]
    )
  end

  private

  def videos_to_hash(videos)
    return [] if videos.blank?

    videos.map do |video|
      {
        id: video.id,
        slug: video.slug,
        title: video.title,
        cover_url: video.cover.url,
        rank: video.rank,
        post_time: time_ago_in_words(video.created_at),
        tag: tag_to_hash(video.tag)
      }
    end
  end

  def tag_to_hash(tag)
    {
      id: tag.id,
      slug: tag.slug,
      title: tag.title
    }
  end
end
