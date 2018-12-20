class RecalculateTopContributorsJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateTopContributorsService.new.call
  end
end
