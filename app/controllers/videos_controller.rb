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

  def destroy
    video = current_user.videos.find_by_slug(params[:video_slug])
    video.destroy if video.present?
  end
end
