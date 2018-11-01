class UpdateUntaggedVideoJob < ApplicationJob
  def perform(*args)
    UpdateUntaggedVideoService.new.call
  end
end
