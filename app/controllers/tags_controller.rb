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
    @tag_videos = @tag.videos.order(rank: :asc)
  end
end
