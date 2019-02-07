class RecalculateVideosRankJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateVideosRankService.new.call
  rescue => e
    ExceptionLogger.create(source: 'RecalculateVideosRankJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateVideosRankJob#perform' })
  end
end
