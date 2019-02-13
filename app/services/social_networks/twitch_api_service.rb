class SocialNetworks::TwitchApiService
  def initialize(video_id, type)
    @video_id = video_id
    @type = type
  end

  def call
    case @type
    when 'video'
      video_url = "https://api.twitch.tv/kraken/videos/#{@video_id}"
      response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
      parsed_body = JSON.parse(response_body)

      api_data = {
        type: 'video',
        title:  parsed_body['title'],
        remote_cover_url: parsed_body['preview']
      }
    when 'clip'
      video_url = "https://clips.twitch.tv/api/v2/clips/#{@video_id}"
      response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
      parsed_body = JSON.parse(response_body)

      api_data = {
        type: 'clip',
        title:  parsed_body['title'],
        remote_cover_url: parsed_body['preview_image']
      }
    when 'stream'
      video_url = "https://api.twitch.tv/kraken/streams/#{@video_id}"
      response_body = RestClient.get(video_url, { params: { client_id: ENV['TWITCH_APP_ID'] }}).body
      parsed_body = JSON.parse(response_body)

      api_data = {
        type: 'stream',
        stream_available: parsed_body['stream'].present?,
        title:  parsed_body.dig('stream', 'game'),
        remote_cover_url: parsed_body.dig('stream', 'preview','medium' )
      }
    end

    api_data
  end
end
