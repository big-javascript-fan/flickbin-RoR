# frozen_string_literal: true

class UpdateThumbnailsForVideosService < ApplicationService
  def initialize; end

  def call
    Video.where(cover: nil).find_each do |video|
      yt_data = SocialNetworks::YoutubeApiService.new(video.source_id).call
      unless yt_data[:remote_cover_url].nil?
        video.update(
          remote_cover_url: yt_data[:remote_cover_url],
          high_quality_cover: yt_data[:high_quality_cover]
        )
      end
    rescue StandardError
      # video.delete
    end
  rescue StandardError => e
    ExceptionLogger.create(source: 'UpdateThumbnailsForVideosService#call', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'UpdateThumbnailsForVideosService#call' })
  end
end
