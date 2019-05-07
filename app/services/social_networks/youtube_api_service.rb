class SocialNetworks::YoutubeApiService
  def initialize(video_id)
    @video_id = video_id
  end

  def call
    youtube_video = Yt::Video.new(id: @video_id)
    remote_cover_url = youtube_video&.snippet&.data.dig('thumbnails', 'standard', 'url')

    data = {
      title: youtube_video.title,
      remote_cover_url: remote_cover_url,
      embeddable: youtube_video.embeddable?
    }

    data
  end
end
