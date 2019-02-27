class OnceAWeekOnFridaysJob < ApplicationJob
  queue_as :mailers

  def perform
    top_5_tags = Tag.order(rank: :asc).includes(top_3_videos: :user).limit(5)
    User.where.not(role: 'dummy').find_each do |user|
      ApplicationMailer::once_a_week_on_fridays(user, top_5_tags).deliver_now
    end
  end
end
