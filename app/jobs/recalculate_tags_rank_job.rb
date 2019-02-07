class RecalculateTagsRankJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateTagsRankService.new.call
  rescue => e
    ExceptionLogger.create(source: 'RecalculateTagsRankJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateTagsRankJob#perform' })
  end
end
