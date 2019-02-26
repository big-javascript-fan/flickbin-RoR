class Notifications::TopContributorsService
  def call
    tags = Tag.joins(:videos)
              .where(videos: { removed: false })
              .distinct
                     
    tags.each do |tag|
      top_11_contributors = get_contributiors_for_tag(tag.id, 11)
      notification_handler(top_11_contributors, tag)
    end
  end

  private

  def get_contributiors_for_tag(tag_id, limit)
    if Rails.env.development?
      User.joins(:contribution_points)
           .where(contribution_points: { tag_id: tag_id })
           .order('contribution_points.amount DESC')
           .limit(limit)
    else
      User.joins(:contribution_points)
           .where.not(users: { role: 'dummy', email: AppConstants::NOT_RATED_USER_EMAILS })
           .where(contribution_points: { tag_id: tag_id })
           .order('contribution_points.amount DESC')
           .limit(limit)
    end
  end

  def notification_handler(contributors, tag)
    contributors.each_with_index do |contributor, index|
      if index == 0
        event_and_notification_handler(contributor, tag, 'top_1_contributor')
      elsif [1, 2].include?(index)
        event_and_notification_handler(contributor, tag, 'top_3_contributors')
      elsif [4, 5].include?(index) && contribution_points.size > 10
        event_and_notification_handler(contributor, tag, 'top_5_contributors')
      elsif (6..10).include?(index) && contribution_points.size > 10
        event_and_notification_handler(contributor, tag, 'top_10_contributors')
      end
    end
  end

  def event_and_notification_handler(user, tag, category)
    last_user_event = user.events.where("event_object ->> 'tag' = '#{tag.id}'").last
    if last_user_event.blank? || last_user_event.category != category
      Event.create(
        user_id: user.id,
        category: category,
        event_object: { tag: tag.id }
      )
    end

    if last_user_event.present? && last_user_event.category == 'top_1_contributor' && category != 'top_1_contributor'
      ApplicationMailer.kicked_out_of_top_contributor(tag, user).deliver_now
    end

    if allowed_to_create_new_notification?(user, tag.id, category)
      Notification.create(
        user_id: user.id,
        category: category,
        event_object: { tag: tag.id }
      )

      ApplicationMailer.send(category, tag, user).deliver_now
    end
  end

  def allowed_to_create_new_notification?(user, tag_id, category)
    already_notificated_categories = user.notifications
                                         .where("event_object ->> 'tag' = '#{tag_id}'")
                                         .pluck(:category)

    positions = already_notificated_categories.map { |c| c[/(\d+)_contributor/, 1] }
    top_position = positions.sort.first.to_i
    new_position = category[/(\d+)_contributor/, 1].to_i

    top_position > 0 && new_position >= top_position ? false : true
  end
end