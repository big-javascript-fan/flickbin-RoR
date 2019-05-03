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
        rank: video.rank,
        source: video.source,
        user: video.user,
        tag: video.tag
      }
    end
  end
end
