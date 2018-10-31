class RecalculateVideosRankJob < ApplicationJob
  def perform(*args)
    RecalculateVideosRankService.new.call
  end
end
