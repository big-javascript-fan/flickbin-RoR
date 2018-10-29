class TagsController < ApplicationController
  def new
    @tag = Tag.new
  end

  def create
  end

  def index
    tags = Tag.order(first_character: :asc)

    if params[:first_char].present?
      tags = tags.where(first_character: params[:first_char]&.first)
    end

    if params[:query].present?
      tags = tags.where('title ILIKE ?', "%#{params[:query]}%")
    end

    @grouped_tags = tags.select(:id, :slug, :title, :first_character)
                        .limit(200)
                        .group_by(&:first_character)
  end

  def show
    @tag = Tag.friendly.find(params[:tag_slug])

    if params[:sort_by] == 'newest'
      @tag_videos = Video.where(tag_id: @tag.id).order(created_at: :desc).limit(10)
    else
      @tag_videos = Video.where(tag_id: @tag.id).order(rank: :asc).limit(10)
    end
  end
end
