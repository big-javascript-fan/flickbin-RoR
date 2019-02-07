class Api::V1::NotificationsController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:index]

  def index
    notifications = current_user.notifications
                                .limit(15)
                                .order(created_at: :desc)

    current_page_notifications = notifications.page(params[:page]).per(3)
    render json: Api::V1::Notifications::IndexSerializer.new(notifications, current_page_notifications).call
  end

  def update
    Notification.where(id: params[:ids]).update_all(read: true)
    no_unread_notifications = current_user.notifications.unread.blank?
    render json: { no_unread_notifications: no_unread_notifications }
  end
end
