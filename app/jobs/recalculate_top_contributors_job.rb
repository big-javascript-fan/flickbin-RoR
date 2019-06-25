# frozen_string_literal: true

class RecalculateTopContributorsJob < ApplicationJob
  queue_as :rank_contributor_cal

  def perform(*_args)
    RecalculateTopContributorsService.new.call
    Notifications::TopContributorsService.new.call
  end
end
