# frozen_string_literal: true

class SocialNetworks::FacebookApiService
  BASE_FACEBOOK_API_URL = 'https://graph.facebook.com/v3.2'

  def initialize(video_id)
    @video_id = video_id
  end

  def call
    access_token = "#{ENV['FACEBOOK_APP_ID']}|#{ENV['FACEBOOK_APP_SECRET']}"
    video_url = "#{BASE_FACEBOOK_API_URL}/#{@video_id}"
    response_body = RestClient.get(video_url, params: { access_token: access_token }).body
    parsed_body = JSON.parse(response_body)

    data = {
      title: parsed_body['description'],
      remote_cover_url: "https://graph.facebook.com/#{facebook_video_id}/picture"
    }

    data
  end
end
