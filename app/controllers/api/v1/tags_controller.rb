class Api::V1::TagsController < Api::V1::BaseController
  def create
    tag = Tag.find_or_initialize_by(title: create_params[:title])

    if tag.save
      render json: tag.to_json(only: [:id, :slug, :title])
    else
      render json: tag.errors.messages, status: 422
    end
  end

  def index
    tags = Tag.where('title ILIKE ?', "%#{params[:query]}%").limit(10)
    render json: tags.to_json(only: [:id, :slug, :title])
  end

  def show
    tag = Tag.friendly.find(params[:tag_slug])

    if params[:sort_by] == 'newest'
      tag_videos = Video.where(tag_id: tag.id).order(created_at: :desc)
    else
      tag_videos = Video.where(tag_id: tag.id).order(rank: :asc)
    end

    tag_videos = tag_videos.page(params[:page]).per(10)
    render json: Api::V1::Tags::Videos::IndexSerializer.new(tag_videos).call
  end

  private

  def create_params
    params.permit(:title)
  end
end
