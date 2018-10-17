class Api::V1::Home::VideosController < Api::V1::BaseController
  def index
    videos_top_1_tag = Video.where(tag_id: params[:top_1_tag_id])
                            .order(rank: :asc)
                            .page(params[:page])
                            .per(10)
    videos_top_2_tag = Video.where(tag_id: params[:top_2_tag_id])
                            .order(rank: :asc)
                            .page(params[:page])
                            .per(10)


    render json: {
      videos_top_1_tag: Api::V1::Home::Videos::IndexSerializer.new(videos_top_1_tag).call,
      videos_top_2_tag: Api::V1::Home::Videos::IndexSerializer.new(videos_top_2_tag).call
    }
  end
end
