class RecalculateTopContributorsJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateTopContributorsService.new.call
  rescue => e
    ExceptionLogger.create(source: 'RecalculateTopContributorsJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateTopContributorsJob#perform' })
  end
end
