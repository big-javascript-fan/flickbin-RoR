class FacebookAdditionalDataService
  BASE_FACEBOOK_API_URL = 'https://graph.facebook.com/v3.2/'

  def initialize(video)
    @video = video
  end

  def call
    return if ENV['FACEBOOK_APP_ID'].blank? || ENV['FACEBOOK_APP_SECRET'].blank?
byebug
    facebook_video_id = VideoHelper.get_video_id_form_facebook_url(@video.url)
    return @video.errors.add(:invalid_url, 'Oops, try a Facebook video link instead.') if facebook_video_id.blank?

    access_token = "#{ENV['FACEBOOK_APP_ID']}|#{ENV['FACEBOOK_APP_SECRET']}"
    video_url = BASE_FACEBOOK_API_URL + facebook_video_id
    response_body = RestClient.get(video_url, { params: { access_token: access_token }}).body
    parsed_body = JSON.parse(response_body)

    @video.source = 'facebook'
    @video.title = parsed_body['description']
    @video.source_id = facebook_video_id
    @video.remote_cover_url = "https://graph.facebook.com/#{facebook_video_id}/picture"
  rescue => e
    @video.errors.add(:invalid_url, 'Video url invalid')
  end
end
