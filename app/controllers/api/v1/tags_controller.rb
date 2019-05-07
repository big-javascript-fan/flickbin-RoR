# frozen_string_literal: true

class Api::V1::TagsController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create]

  def create
    tag = Tag.find_or_initialize_by(title: create_params[:title])

    if tag.save
      render json: tag.to_json(only: %i[id slug title])
    else
      render json: tag.errors.messages, status: 422
    end
  end

  def index
    tags =
      if params[:query].present?
        Tag.where('title LIKE ?', "%#{params[:query].downcase}%")
           .order('LENGTH(title) ASC')
           .limit(5)
      else
        get_sidebar_tags(params[:number_of_tags_per_page])
      end

    render json: tags.to_json(only: %i[id slug title])
  end

  def show
    sidebar_tags = get_sidebar_tags
    tag = Tag.friendly.find(params[:tag_slug])

    tag_videos = Video.active.tagged.where(tag_id: tag.id)

    tag_videos =
      case params[:sort_by]
      when 'newest'
        tag_videos.order(created_at: :desc)
      when 'top_charts'
        tag_videos.order(rank: :asc, created_at: :desc)
      else
        tag_videos.order(rank: :asc, created_at: :desc)
      end

    tag_videos = tag_videos.page(params[:page]).per(10)
    render json: Api::V1::Tags::IndexSerializer.new(sidebar_tags, tag_videos).call
  end

  def create_params
    params.permit(:title)
  end
end
