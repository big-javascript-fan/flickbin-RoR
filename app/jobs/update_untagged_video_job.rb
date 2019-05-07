# frozen_string_literal: true

class UpdateUntaggedVideoJob < ApplicationJob
  queue_as :video_tag_expiration

  def perform(*_args)
    UpdateUntaggedVideoService.new.call
  rescue StandardError => e
    ExceptionLogger.create(source: 'UpdateUntaggedVideoJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'UpdateUntaggedVideoJob#perform' })
  end
end
