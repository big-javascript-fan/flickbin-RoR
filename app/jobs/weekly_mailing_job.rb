class WeeklyMailingJob < ApplicationJob
  queue_as :mailers

  def perform
    top_3_tags = Tag.order(rank: :asc).includes(top_3_videos: :user).limit(3)
    User.where.not(role: 'dummy').find_each do |user|
      ApplicationMailer::weekly_mailing(user, top_3_tags).deliver_now
    end
  end
end
