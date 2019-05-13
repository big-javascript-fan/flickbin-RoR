# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  def show
    sidebar_tags = get_sidebar_tags
    @user = User.friendly.find(params[:channel_slug])
    videos = @user.videos
                  .active
                  .includes(:tag)
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(10)

    render json: Api::V1::Users::ShowSerializer.new(sidebar_tags, videos, current_user_station: current_user_station?).call
  end

  private

  def current_user_station?
    current_user.present? && current_user.id == @user.id ? true : false
  end
end
