class RecalculateTagsRankJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateTagsRankService.new.call
  end
end
