class Api::V1::NotificationsController < Api::V1::BaseController
  def index
    notifications = current_user.notifications
                                .not_read
                                .order(created_at: :desc)
                                .page(params[:page])
                                .per(1)

    render json: Api::V1::Notifications::IndexSerializer.new(notifications).call
  end

  def update
    Notification.where(id: params[:ids]).update_all(read: true)
    head :ok
  end
end
