# frozen_string_literal: true

class Api::V1::NotificationsController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:index]

  def index
    top_15_notifications = current_user.top_15_notifications
    current_page_notifications = top_15_notifications.page(params[:page]).per(3)
    render json: Api::V1::Notifications::IndexSerializer.new(top_15_notifications, current_page_notifications).call
  end

  def update
    Notification.where(id: params[:ids]).update_all(read: true)
    top_15_notifications = current_user.top_15_notifications
    no_unread_notifications = top_15_notifications.count { |n| n.read == false }.zero?
    render json: { no_unread_notifications: no_unread_notifications }
  end
end
