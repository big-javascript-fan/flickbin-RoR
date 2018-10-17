class Api::V1::Home::TagsController < Api::V1::BaseController
  def index
    tags = Tag.order(rank: :asc)
              .page(params[:page])
              .per(15)
    render json: tags.to_json(only: [:id, :slug, :title])
  end
end
