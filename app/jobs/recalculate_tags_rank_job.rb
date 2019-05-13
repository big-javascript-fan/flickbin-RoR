# frozen_string_literal: true

class RecalculateTagsRankJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*_args)
    RecalculateTagsRankService.new.call
  rescue StandardError => e
    ExceptionLogger.create(source: 'RecalculateTagsRankJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateTagsRankJob#perform' })
  end
end
