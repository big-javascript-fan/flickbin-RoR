class RecalculateVideosRankJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateVideosRankService.new.call
  end
end
