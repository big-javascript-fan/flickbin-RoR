# frozen_string_literal: true

class SocialNetworks::YoutubeApiService
  def initialize(video_id)
    @video_id = video_id
  end

  def call
    youtube_video = Yt::Video.new(id: @video_id)
    yt_snippet_data = youtube_video&.snippet&.data
    remote_cover_url = yt_snippet_data&.dig('thumbnails', 'standard', 'url') || yt_snippet_data&.dig('thumbnails', 'high', 'url')

    {
      title: youtube_video.title,
      remote_cover_url: remote_cover_url,
      embeddable: youtube_video.embeddable?,
      length: youtube_video.length,
      duration: youtube_video.duration
    }
  end
end
