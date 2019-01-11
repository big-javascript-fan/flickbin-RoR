class UpdateUntaggedVideoJob < ApplicationJob
  queue_as :video_tag_expiration

  def perform(*args)
    UpdateUntaggedVideoService.new.call
  end
end
