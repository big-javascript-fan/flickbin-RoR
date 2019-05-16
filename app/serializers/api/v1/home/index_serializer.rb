# frozen_string_literal: true

class Api::V1::Home::IndexSerializer < Api::V1::BaseSerializer
  def initialize(sidebar_tags, videos)
    @sidebar_tags = sidebar_tags
    @videos = videos
  end

  def call
    Oj.dump(
      sidebar_tags: sidebar_tags_to_hash(@sidebar_tags),
      videos: videos_to_hash(@videos)
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
        source: video.source,
        user_slug: video.user_slug,
        user_avatar: video.user_avatar,
        tag_slug: video.tag_slug,
        tag_title: video.tag_title
      }
    end
  end
end
