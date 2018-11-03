class Api::V1::HomeController < Api::V1::BaseController
  def index
    sidebar_tags = get_sidebar_tags
    left_tag = Tag.order(rank: :asc, id: :asc)
                  .offset(params[:offset]&.to_i)
                  .includes(:top_10_videos)
                  .first
    right_tag = Tag.order(rank: :asc, id: :asc)
                   .offset(params[:offset].next&.to_i)
                   .includes(:top_10_videos)
                   .first

    render json: Api::V1::Home::IndexSerializer.new(sidebar_tags, left_tag, right_tag).call
  end
end
