# frozen_string_literal: true

class RecalculateVideosRankJob < ApplicationJob
  queue_as :rank_video_cal

  def perform(*_args)
    RecalculateVideosRankService.new.call
  rescue StandardError => e
    ExceptionLogger.create(source: 'RecalculateVideosRankJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateVideosRankJob#perform' })
  end
end
