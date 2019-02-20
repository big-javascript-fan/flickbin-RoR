class RecalculateTopContributorsService
  def call
    Tag.find_each do |tag|
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
          next unless allowed_to_create_new_notification?(cp.user, 'top_1_contributor', cp.tag_id)

          Notification.new(
            user_id: cp.user_id,
            category: 'top_1_contributor',
            event_object: { tag: cp.tag_id }
          )
        elsif [1, 2].include?(index)
          next unless allowed_to_create_new_notification?(cp.user, 'top_3_contributors', cp.tag_id)

          Notification.new(
            user_id: cp.user_id,
            category: 'top_3_contributors',
            event_object: { tag: cp.tag_id }
          )
        elsif [4, 5].include?(index) && contribution_points.size > 10
          next unless allowed_to_create_new_notification?(cp.user, 'top_5_contributors', cp.tag_id)

          Notification.new(
            user_id: cp.user_id,
            category: 'top_5_contributors',
            event_object: { tag: cp.tag_id }
          )
        elsif (6..10).include?(index) && contribution_points.size > 10
          next unless allowed_to_create_new_notification?(cp.user, 'top_10_contributors', cp.tag_id)

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

  def allowed_to_create_new_notification?(user, category, tag_id)
    already_notificated_categories = user.notifications
                                         .where("event_object ->> 'tag' = '#{tag_id}'")
                                         .pluck(:category)

    positions = already_notificated_categories.map { |c| c[/(\d+)_contributor/, 1] }
    top_position = positions.sort.first.to_i
    new_position = category[/top_(\d+)/, 1].to_i

    top_position > 0 && new_position >= top_position ? false : true
  end
end
