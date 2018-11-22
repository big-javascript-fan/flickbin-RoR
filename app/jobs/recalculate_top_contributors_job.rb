class RecalculateTopContributorsJob < ApplicationJob
  def perform(*args)
    RecalculateTopContributorsService.new.call
  end
end
