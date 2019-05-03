# frozen_string_literal: true

class Api::V1::Tags::IndexSerializer < Api::V1::BaseSerializer
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

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
        id: video.id,
        slug: video.slug,
        title: video.title,
        source: video.source,
        cover_url: video.cover.url,
        rank: video.rank,
        votes_amount: number_with_delimiter(video.votes_amount),
        comments_count: video.comments_count,
        channel_name: video.user.channel_name,
        channel_slug: video.user.slug,
        user_rank: video.user.rank.positive? ? video.user.rank : 0,
        post_time: time_ago_in_words(video.created_at)
      }
    end
  end
end
