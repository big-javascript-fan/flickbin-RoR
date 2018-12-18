class RecalculateTopContributorsService
  def call
    Tag.find_each do |tag|
      next if tag.title != 'music'
      recalculate_contributors_rank(tag)

      top_11_contribution_points = get_contribution_points_for_tag(tag, 11)
      contributors_notification_handler(top_11_contribution_points)
    end
  end

  private

  def recalculate_contributors_rank(tag)
    contributors = tag.users
    unless Rails.env.development?
      contributors = contributors.where.not(role: 'dummy', email: AppConstants::NOT_RATED_USER_EMAILS)
    end

    contributors.each do |contributor|
      amount = 0
      contributor.videos.where(tag_id: tag.id, removed: false).each do |video|
        amount += (video.positive_votes_amount + 1)
      end

      cp = ContributionPoint.find_or_initialize_by(tag_id: tag.id, user_id: contributor.id)
      cp.update(amount: amount)
    end
  end

  def get_contribution_points_for_tag(tag, limit)
    if Rails.env.development?
      tag.contribution_points
         .includes(:user)
         .where('contribution_points.amount > ?', 0)
         .order(amount: :desc)
         .limit(limit)
    else
      tag.contribution_points
         .includes(:user)
         .where.not(users: { role: 'dummy', email: AppConstants::NOT_RATED_USER_EMAILS })
         .where('contribution_points.amount > ?', 0)
         .order(amount: :desc)
         .limit(limit)
    end
  end

  def contributors_notification_handler(contribution_points)
    contribution_points.each_with_index do |cp, index|
      notification =
        if index == 0
          Notification.new(
            user_id: cp.user_id,
            category: 'top_1_contributor',
            event_object: { tag: cp.tag_id }
          )
        elsif index == 2
          Notification.new(
            user_id: cp.user_id,
            category: 'top_3_contributors',
            event_object: { tag: cp.tag_id }
          )
        elsif index == 4 && contribution_points.size > 10
          Notification.new(
            user_id: cp.user_id,
            category: 'top_5_contributors',
            event_object: { tag: cp.tag_id }
          )
        elsif index == 9 && contribution_points.size > 10
          Notification.new(
            user_id: cp.user_id,
            category: 'top_10_contributors',
            event_object: { tag: cp.tag_id }
          )
        end

      if notification.present? && notification.save!
        ApplicationMailer.send(notification.category, cp.tag, cp.user).deliver_now
      end
    end
  end
end
