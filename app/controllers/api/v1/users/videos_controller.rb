class Api::V1::Users::VideosController < Api::V1::BaseController
  def index
    user = User.friendly.find(params[:channel_slug])
    videos = user.videos
                 .active
                 .includes(:tag)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(10)

    render json: Api::V1::Users::Videos::IndexSerializer.new(videos).call
  end
end
