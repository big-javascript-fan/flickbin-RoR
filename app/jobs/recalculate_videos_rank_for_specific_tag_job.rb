class RecalculateVideosRankForSpecificTagJob < ApplicationJob
  queue_as :rank_calculation

  def perform(tag)
    RecalculateVideosRankForSpecificTagService.new(tag).call
  rescue => e
    ExceptionLogger.create(source: 'RecalculateVideosRankForSpecificTagJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateVideosRankForSpecificTagJob#perform' })
  end
end
