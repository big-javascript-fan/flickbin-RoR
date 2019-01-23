class TwitchAdditionalDataService
  def initialize(video)
    @video = video
  end

  def call
    return if ENV['TWITCH_APP_ID'].blank?

    case @video.url
    when /\/clip\//
      base_twitch_api_url = 'https://clips.twitch.tv/api/v2/clips'
      twitch_clip_slug = VideoHelper.get_clip_slug_form_twitch_url(@video.url)
      return @video.errors.add(:invalid_url, 'Oops, try a Twitch video link instead.') if twitch_clip_slug.blank?

      video_url = "#{base_twitch_api_url}/#{twitch_clip_slug}"
      response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
      parsed_body = JSON.parse(response_body)

      @video.kind_of = 'clip'
      @video.source = 'twitch'
      @video.title = parsed_body['title']
      @video.source_id = twitch_clip_slug
      @video.remote_cover_url = parsed_body['preview_image']
    when /\/videos\//
      base_twitch_api_url = 'https://api.twitch.tv/kraken/videos'
      twitch_video_id = VideoHelper.get_video_id_form_twitch_url(@video.url)
      return @video.errors.add(:invalid_url, 'Oops, try a Twitch video link instead.') if twitch_video_id.blank?

      video_url = "#{base_twitch_api_url}/#{twitch_video_id}"
      response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
      parsed_body = JSON.parse(response_body)

      @video.kind_of = 'video'
      @video.source = 'twitch'
      @video.title = parsed_body['title']
      @video.source_id = twitch_video_id
      @video.remote_cover_url = parsed_body['preview']
    when /\/streams\//
      twitch_video_id = VideoHelper.get_video_id_form_twitch_url(@video.url)
      return @video.errors.add(:invalid_url, 'Oops, try a Twitch video link instead.') if twitch_video_id.blank?

      video_url = "#{BASE_TWITCH_API_URL}/kraken/videos/#{twitch_video_id}"
      response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
      parsed_body = JSON.parse(response_body)

      @video.kind_of = 'stream'
      @video.source = 'twitch'
      @video.title = parsed_body['title']
      @video.source_id = twitch_video_id
      @video.remote_cover_url = parsed_body['preview']
    else
      @video.errors.add(:invalid_url, 'Video url invalid')
    end
  rescue => e
    @video.errors.add(:invalid_url, 'Video url invalid')
  end
end
