class Api::V1::TagsController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create]

  def create
    tag = Tag.find_or_initialize_by(title: create_params[:title])

    if tag.save
      render json: tag.to_json(only: [:id, :slug, :title])
    else
      render json: tag.errors.messages, status: 422
    end
  end

  def index
    tags =
      if params[:query].present?
        Tag.where('title ILIKE ?', "%#{params[:query]}%").limit(10)
      else
        Tag.order(rank: :asc).page(params[:page]).per(28)
      end

    render json: tags.to_json(only: [:id, :slug, :title])
  end

  def show
    sidebar_tags = get_sidebar_tags(35)
    tag = Tag.friendly.find(params[:tag_slug])

    tag_videos =
      case params[:sort_by]
      when 'newest'
        Video.where(tag_id: tag.id).order(created_at: :desc)
      when 'top_charts'
        Video.where(tag_id: tag.id).order(rank: :asc)
      else
        Video.where(tag_id: tag.id).order(rank: :asc)
      end

    tag_videos = tag_videos.page(params[:page]).per(10)
    render json: Api::V1::Tags::IndexSerializer.new(sidebar_tags, tag_videos).call
  end

  def create_params
    params.permit(:title)
  end
end
