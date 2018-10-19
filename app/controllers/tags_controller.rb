class TagsController < ApplicationController
  def new
    @tag = Tag.new
  end

  def create

  end

  def index
    @tags = Tag.all.order(rank: :asc)
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
