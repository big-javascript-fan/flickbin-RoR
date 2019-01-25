class DailyMotionAdditionalDataService
  BASE_DAYLI_MOTION_API_URL = 'https://api.dailymotion.com'

  def initialize(video)
    @video = video
  end

  def call
    daily_motion_video_id = VideoHelper.get_video_id_form_daily_motion_url(@video.url)
    return @video.errors.add(:invalid_url, 'Oops, try a Daily Motion video link instead.') if daily_motion_video_id.blank?

    video_url = "#{BASE_DAYLI_MOTION_API_URL}/video/#{daily_motion_video_id}"
    response_body = RestClient.get(video_url).body
    parsed_body = JSON.parse(response_body)

    @video.kind_of = 'video'
    @video.source = 'daily_motion'
    @video.title = parsed_body['title']
    @video.source_id = daily_motion_video_id
    @video.remote_cover_url = "https://www.dailymotion.com/thumbnail/video/#{daily_motion_video_id}"
  rescue => e
    @video.errors.add(:invalid_url, 'Video url invalid')
  end
end
