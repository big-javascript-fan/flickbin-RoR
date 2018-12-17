class Api::V1::Notifications::IndexSerializer < Api::V1::BaseSerializer
  def initialize(notifications)
    @notifications = notifications
  end

  def call
    Oj.dump(
      notifications: notifications_to_hash(@notifications),
      total_pages: @notifications.total_pages
    )
  end

  private

  def notifications_to_hash(notifications)
    return [] if notifications.blank?

    notifications.map do |notification|
      {
        id:           notification.id,
        message:      notification.message,
        category:     notification.category,
        event_object: notification.event_object
      }
    end
  end
end
