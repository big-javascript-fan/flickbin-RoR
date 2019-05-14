# frozen_string_literal: true

class SocialNetworks::DailyMotionApiService
  BASE_DAYLI_MOTION_API_URL = 'https://api.dailymotion.com'

  def initialize(video_id)
    @video_id = video_id
  end

  def call
    video_url = "#{BASE_DAYLI_MOTION_API_URL}/video/#{@video_id}"
    response_body = RestClient.get(video_url).body
    parsed_body = JSON.parse(response_body)
    remote_cover_url = "https://www.dailymotion.com/thumbnail/video/#{@video_id}"

    data = {
      title: parsed_body['title'],
      remote_cover_url: remote_cover_url,
      channel: parsed_body['channel']
    }

    data
  end
end
