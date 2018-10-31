class RecalculateTagsRankJob < ApplicationJob
  def perform(*args)
    RecalculateTagsRankService.new.call
  end
end
