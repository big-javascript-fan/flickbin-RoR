class WeeklyMailingJob < ApplicationJob
  queue_as :mailers

  def perform
    top_5_tags = tags = Tag.order(rank: :asc).includes(top_3_videos: :user).limit(5)
    User.where.not(role: 'dummy').find_each do |user|
      ApplicationMailer::weekly(user, top_5_tags).deliver_now
    end
  end
end
