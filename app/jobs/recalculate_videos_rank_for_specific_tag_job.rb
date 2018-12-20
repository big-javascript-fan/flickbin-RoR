class RecalculateVideosRankForSpecificTagJob < ApplicationJob
  queue_as :rank_calculation

  def perform(tag)
    RecalculateVideosRankForSpecificTagService.new(tag).call
  end
end
