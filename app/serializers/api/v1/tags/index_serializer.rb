class Api::V1::Tags::IndexSerializer < Api::V1::BaseSerializer
  include ActionView::Helpers::DateHelper

  def initialize(sidebar_tags, videos)
    @sidebar_tags = sidebar_tags
    @videos = videos
  end

  def call
    Oj.dump(
      sidebar_tags: sidebar_tags_to_hash(@sidebar_tags),
      tag_videos: videos_to_hash(@videos)
    )
  end

  private

  def videos_to_hash(videos)
    return [] if videos.blank?

    videos.map do |video|
      {
        id:        video.id,
        slug:      video.slug,
        title:     video.title,
        cover_url: video.cover.url,
        rank:      video.rank,
        post_time: time_ago_in_words(video.created_at)
      }
    end
  end
end
