# frozen_string_literal: true

class WeeklyMailingJob < ApplicationJob
  queue_as :mailers

  def perform
    Notifications::WeeklyMailingService.new.call
  end
end
