# frozen_string_literal: true

class UpdateThumbnailsForVideosJob < ApplicationJob
  queue_as :thumbnail_for_video

  def perform(*_args)
    UpdateThumbnailsForVideosService.call
  rescue StandardError => e
    ExceptionLogger.create(source: 'UpdateThumbnailsForVideosJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'UpdateThumbnailsForVideosJob#perform' })
  end
end
