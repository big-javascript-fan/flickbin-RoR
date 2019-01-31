module VideoHelper
  def self.get_video_id_form_youtube_url(url)
    if url.include?('/watch')
      url[/\/watch\?v=([^&.]+)/, 1]
    elsif url.include?('v=')
      url.split('?').last.split('v=').last
    else
      url.split('/').last
    end
  end

  def self.get_video_id_form_facebook_url(url)
    url[/videos\/(\d+)/, 1]
  end

  def self.get_video_id_with_type_from_twitch_url(video_url)
    case video_url
    when /\/clip\//
      { video_id: get_clip_slug_form_twitch_url(video_url), kind_of: 'clip' }
    when /\/videos\//
      { video_id: get_video_id_form_twitch_url(video_url), kind_of: 'video' }
    else
      { video_id: get_channel_id_form_twitch_url(video_url), kind_of: 'stream' }
    end
  end

  def self.get_video_id_form_twitch_url(url)
    url[/videos\/(\d+)/, 1]
  end

  def self.get_clip_slug_form_twitch_url(url)
    url[/clip\/(\w+)/, 1]
  end

  def self.get_channel_id_form_twitch_url(url)
    url[/twitch.tv\/(\w+)/, 1]
  end

  def self.get_video_id_form_daily_motion_url(url)
    url[/video\/(\w+)/, 1]
  end
end
