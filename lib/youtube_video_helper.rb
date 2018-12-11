module YoutubeVideoHelper
  def self.get_video_id_form_youtube_url(url)
    url[/\/watch\?v=([^&.]+)/, 1] || url.split('?').last.split('v=').last
  end
end
