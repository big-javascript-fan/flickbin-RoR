class RecalculateTopContributorsJob < ApplicationJob
  queue_as :rank_calculation

  def perform(*args)
    RecalculateTopContributorsService.new.call
    Notifications::TopContributorsService.new.call
  end
end
