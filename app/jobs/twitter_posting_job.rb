class TwitterPostingJob < ApplicationJob
  queue_as :twitter_posting

  def perform(video_id)
    TwitterPostingService.new(video_id).call
  end
end
