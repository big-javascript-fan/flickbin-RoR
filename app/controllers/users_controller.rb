class UsersController < ApplicationController
  def show
    @sidebar_tags = get_sidebar_tags
    @user = User.friendly.find(params[:channel_slug])
    @user_videos = Video.includes(:tag)
                        .active
                        .tagged
                        .where(user_id: @user.id)
                        .order(created_at: :desc)
                        .limit(10)
  end

  private

  def get_sidebar_tags
    @sidebar_tags ||= Tag.order(rank: :asc).limit(30)
  end
end
