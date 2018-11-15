class RecalculateVideosRankForSpecificTagJob < ApplicationJob
  def perform(tag)
    RecalculateVideosRankForSpecificTagService.new(tag).call
  end
end
