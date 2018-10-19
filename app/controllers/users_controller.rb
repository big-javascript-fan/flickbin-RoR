class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:channel_slug])
    @user_videos = @user.videos
                        .active
                        .tagged
                        .includes(:tag)
                        .order(created_at: :desc)
                        .limit(10)
  end
end
