class YoutubeAdditionalDataService
  def initialize(video)
    @video = video
  end

  def call
    youtube_video_id = VideoHelper.get_video_id_form_youtube_url(@video.url)
    return @video.errors.add(:invalid_url, 'Oops, try a YouTube link instead.') if youtube_video_id.blank?

    youtube_video = Yt::Video.new id: youtube_video_id
    return @video.errors.add(:invalid_url, 'This video cannot be embedded.') unless youtube_video.embeddable?

    @video.source = 'youtube'
    @video.title = youtube_video.title
    @video.source_id = youtube_video_id
    @video.remote_cover_url = youtube_video&.snippet&.data.dig('thumbnails', 'medium', 'url')
  rescue => e
    @video.errors.add(:invalid_url, 'Video url invalid')
  end
end
