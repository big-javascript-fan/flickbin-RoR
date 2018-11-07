class Api::V1::UsersController < Api::V1::BaseController
  def show
    sidebar_tags = get_sidebar_tags
    user = User.friendly.find(params[:channel_slug])
    videos = user.videos
                 .active
                 .includes(:tag)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(10)

    render json: Api::V1::Users::ShowSerializer.new(sidebar_tags, videos).call
  end
end
