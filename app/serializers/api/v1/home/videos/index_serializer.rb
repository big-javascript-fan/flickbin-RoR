class Api::V1::Home::Videos::IndexSerializer
  def initialize(left_tag, right_tag)
    @left_tag = left_tag
    @right_tag = right_tag
  end

  def call
    Oj.dump({
      left_tag: tag_to_hash(@left_tag),
      right_tag: tag_to_hash(@right_tag)
    })
  end

  private

  def tag_to_hash(tag)
    {
      id:            tag.id,
      title:         tag.title,
      slug:          tag.slug,
      rank:          tag.rank,
      top_10_videos: videos_to_hash(tag.top_10_videos)
    }
  end


  def videos_to_hash(videos)
    return [] if videos.blank?

    videos.map do |video|
      {
        id:        video.id,
        slug:      video.slug,
        title:     video.title,
        cover_url: video.cover.url,
        rank:      video.rank
      }
    end
  end
end
