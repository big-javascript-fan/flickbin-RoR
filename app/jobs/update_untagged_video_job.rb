class UpdateUntaggedVideoJob < ApplicationJob
  queue_as :video_tag_expiration

  def perform(*args)
    UpdateUntaggedVideoService.new.call
  rescue => e
    ExceptionLogger.create(source: 'UpdateUntaggedVideoJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'UpdateUntaggedVideoJob#perform' })
  end
end
