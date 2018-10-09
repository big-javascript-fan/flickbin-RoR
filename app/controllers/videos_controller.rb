class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create

  end

  def index
    @videos = Video.all.order(asc: :rank)
  end

  def show
    @video = Video.friendly.find(params[:video_slug])
  end
end
