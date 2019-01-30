class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def new
    @sidebar_tags = get_sidebar_tags
    @video = current_user.videos.build
  end

  def create
    @video = current_user.videos.build(create_params)
    @sidebar_tags = get_sidebar_tags

    if @video.save
      render :create
    elsif @video.errors.messages[:invalid_url].present? || @video.errors.details[:url].first[:error] == :invalid
      @invalid_video_url = true
      render :new
    else
      @existing_video = Video.active
                             .tagged
                             .includes(:tag)
                             .where(tag_id: create_params[:tag_id], url: create_params[:url])
                             .first
      render :new
    end
  end

  def show
    @sidebar_tags = get_sidebar_tags(70)
    @video = Video.friendly.find(params[:video_slug])
    @last_hour_upvotes = @video.votes
                               .where("votes.value = 1 AND votes.created_at BETWEEN '#{1.hour.ago.to_s}' AND '#{Time.now}'")
                               .count
    @video_owner = @video.user
    @tag = @video.tag
    comments = @video.comments
                     .roots
                     .includes(:commentator)
                     .order(created_at: :desc)

    comments = comments.limit(6) unless params[:all_comments].present?
    @comments_tree = comments.map { |comment| comment.subtree(to_depth: 1).arrange }

    if current_user.present?
      @vote = Vote.find_by(voter_id: current_user.id, video_id: @video.id)
    end
  end

  def destroy
    video = current_user.videos.find_by_slug(params[:video_slug])

    if video.present?
      video.update_attribute(:removed, true)
    else
      render js: "alert('Video with slug - \"#{params[:video_slug]}\" not found')"
    end
  end

  def create_params
    params.fetch(:video, {}).permit(:url, :tag_name, :tag_id)
  end
end
