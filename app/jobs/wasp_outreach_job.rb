class WaspOutreachJob < ApplicationJob
  def perform(video_id)
    WaspOutreachService.new(video_id).call
  end
end
