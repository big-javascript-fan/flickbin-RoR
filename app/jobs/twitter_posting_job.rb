class TwitterPostingJob < ApplicationJob
  def perform(video_id)
    TwitterPostingService.new(video_id).call
  end
end
