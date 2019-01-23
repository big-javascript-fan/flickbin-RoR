module VideoHelper
  def self.get_video_id_form_youtube_url(url)
    url[/\/watch\?v=([^&.]+)/, 1] || url.split('?').last.split('v=').last
  end

  def self.get_video_id_form_facebook_url(url)
    url[/videos\/(\d+)/, 1]
  end

  def self.get_video_id_form_twitch_url(url)
    url[/videos\/(\d+)/, 1]
  end

  def self.get_clip_slug_form_twitch_url(url)
    url[/clip\/(\w+)/, 1]
  end

  def self.get_video_id_form_daily_motion_url(url)
    url[/videos\/(\d+)/, 1]
  end
end
