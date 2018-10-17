class Api::V1::Home::Videos::IndexSerializer
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
        cover_url: video.cover.url
      }
    end
  end
end
