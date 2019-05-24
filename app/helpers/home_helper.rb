# frozen_string_literal: true

module HomeHelper
  def home_cover_for(video)
    video.cover.url.to_s
  end

  def home_slug_for(video)
    video.slug
  end

  def home_title_for(video)
    video.title
  end

  def home_source_for(video)
    video.source
  end

  def home_user_avatar_for(video)
    video.user_avatar.url
  end

  def home_user_avatar_thumb_44x44_for(video)
    home_user_avatar_for(video).thumb_44x44
  end

  def home_user_channel_name_for(video)
    video.user_channel_name
  end

  def home_user_slug(video)
    video.user_slug
  end

  def home_tag_title_for(video)
    video.tag_title
  end

  def home_tag_slug_for(video)
    video.tag_slug
  end

  def home_video_from_youtube?(video)
    home_source_for(video) == 'youtube'
  end

  def home_video_from_daily_motion?(video)
    home_source_for(video) == 'daily_motion'
  end

  def home_video_from_twitch?(video)
    home_source_for(video) == 'twitch'
  end
end
