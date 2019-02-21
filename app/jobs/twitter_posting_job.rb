class TwitterPostingJob < ApplicationJob
  queue_as :twitter_posting

  def perform(video_id)
    TwitterPostingService.new(video_id).call
  rescue => e
    ExceptionLogger.create(source: 'TwitterPostingJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'TwitterPostingJob#perform' })
  end
end
