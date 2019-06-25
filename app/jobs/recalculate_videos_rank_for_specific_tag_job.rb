# frozen_string_literal: true

class RecalculateVideosRankForSpecificTagJob < ApplicationJob
  queue_as :rank_video_special_cal

  def perform(tag)
    RecalculateVideosRankForSpecificTagService.new(tag).call
  rescue StandardError => e
    ExceptionLogger.create(source: 'RecalculateVideosRankForSpecificTagJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'RecalculateVideosRankForSpecificTagJob#perform' })
  end
end
