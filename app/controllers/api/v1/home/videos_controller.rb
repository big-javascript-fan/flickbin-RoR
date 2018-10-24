class Api::V1::Home::VideosController < Api::V1::BaseController
  def index
    left_tag = Tag.order(rank: :asc)
                  .offset(params[:offset]&.to_i)
                  .includes(:top_10_videos)
                  .first
    right_tag = Tag.order(rank: :asc)
                   .offset(params[:offset].next&.to_i)
                   .includes(:top_10_videos)
                   .first

    render json: Api::V1::Home::Videos::IndexSerializer.new(left_tag, right_tag).call
  end
end
