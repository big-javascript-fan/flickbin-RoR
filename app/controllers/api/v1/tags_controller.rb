class Api::V1::TagsController < Api::V1::BaseController
  def index
    tags = Tag.where('title ILIKE ?', "%#{params[:query]}%").limit(10)
    render json: tags.to_json(only: [:id, :slug, :title])
  end
end
