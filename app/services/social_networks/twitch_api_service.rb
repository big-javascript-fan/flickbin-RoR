class SocialNetworks::TwitchApiService
  def initialize(video_id, type)
    @video_id = video_id
    @type = type
  end

  def call
    video_url = get_video_url
    response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
    parsed_body = JSON.parse(response_body)

    data = {
      title:  parsed_body['title'],
      remote_cover_url: parsed_body['preview_image']
    }

    data
  end

  private

  def get_video_url
    case @type
    when 'video'
      "https://api.twitch.tv/kraken/videos/#{@video_id}"
    when 'clip'
      "https://clips.twitch.tv/api/v2/clips/#{@video_id}"
    when 'stream'
      "https://api.twitch.tv/kraken/streams/#{@video_id}"
    end
  end
end
