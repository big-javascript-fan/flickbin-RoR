class Api::V1::Videos::IndexSerializer
  include ActionView::Helpers::DateHelper

  def initialize(videos)
    @videos = videos
  end

  def call
    Oj.dump(videos_to_hash(@videos))
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
        post_time: time_ago_in_words(video.created_at),
        tag:       tag_to_hash(video.tag)
      }
    end
  end

  def tag_to_hash(tag)
    {
      id:    tag.id,
      slug:  tag.slug,
      title: tag.title
    }
  end
end
