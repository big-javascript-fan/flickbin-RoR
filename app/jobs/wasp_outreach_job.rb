# frozen_string_literal: true

class WaspOutreachJob < ApplicationJob
  queue_as :wasp_post

  def perform(video_id)
    WaspOutreachService.new(video_id).call
  rescue StandardError => e
    ExceptionLogger.create(source: 'WaspOutreachJob#perform', message: e)
    ExceptionNotifier.notify_exception(e, data: { source: 'WaspOutreachJob#perform' })
  end
end
