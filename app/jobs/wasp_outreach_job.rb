class WaspOutreachJob < ApplicationJob
  queue_as :wasp_post

  def perform(video_id)
    WaspOutreachService.new(video_id).call
  end
end
