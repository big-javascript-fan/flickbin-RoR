class VideosController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :destroy]

  def new
    @video = current_user.videos.build
  end

  def create
    @video = current_user.videos.build(create_params)

    if @video.save
      redirect_to station_path(current_user), notice: 'Your video has been shared!'
    elsif @video.errors.messages[:invalid_url].present?
      @invalid_video_url = true
      render :new
    else
      @existing_video = Video.includes(:tag)
                             .where(tag_id: create_params[:tag_id], url: create_params[:url])
                             .first
      render :new
    end
  end

  def show
    @video = Video.friendly.find(params[:video_slug])
  end

  def destroy
    video = current_user.videos.find_by_slug(params[:video_slug])
    video.destroy if video.present?
  end

  private

  def create_params
    params.fetch(:video, {}).permit(:url, :tag_name, :tag_id)
  end
end
