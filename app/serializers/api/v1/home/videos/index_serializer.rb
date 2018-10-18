class Api::V1::Home::Videos::IndexSerializer
  def initialize(videos_top_1_tag, videos_top_2_tag)
    @videos_top_1_tag = videos_top_1_tag
    @videos_top_2_tag = videos_top_2_tag
  end

  def call
    Oj.dump({
      videos_top_1_tag: videos_to_hash(@videos_top_1_tag),
      videos_top_2_tag: videos_to_hash(@videos_top_2_tag)
    })
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
        rank:      video.rank
      }
    end
  end
end
