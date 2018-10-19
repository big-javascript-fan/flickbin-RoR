class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:channel_slug])
    @user_videos = Video.includes(:tag)
                        .active
                        .tagged
                        .where(user_id: @user.id)
                        .order(created_at: :desc)
                        .limit(10)
  end
end
