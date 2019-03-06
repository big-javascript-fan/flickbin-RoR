class SocialNetworks::YoutubeApiService
  def initialize(video_id)
    @video_id = video_id
  end

  def call
    youtube_video = Yt::Video.new(id: @video_id)

    data = {
      title: youtube_video.title,
      remote_cover_url: youtube_video&.snippet&.data.dig('thumbnails', 'medium', 'url'),
      embeddable: youtube_video.embeddable?
    }

    data
  end
end
