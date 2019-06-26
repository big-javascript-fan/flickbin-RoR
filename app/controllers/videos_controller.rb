# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :find_video, only: %i[show]

  def new
    @sidebar_tags = get_sidebar_tags
    @video = current_user.videos.build
  end

  def create
    @video = current_user.videos.build(create_params)
    @sidebar_tags = get_sidebar_tags

    @existing_video = Video.active
                            .tagged
                            .includes(:tag)
                            .where(tag_id: @video.tag_id, url: @video.url)
    
    if @existing_video.exists?
      @invalid_source_id = 'It looks like this video has already been posted within ' + @existing_video.first.tag.title + '. Try again in '+ @existing_video.first.remaining_days.to_s + ' days.'
      @second_step = true
      render :new
    else
      if @video.save
        render :create
      elsif @video.errors.messages[:invalid_url].present?
        @invalid_video_url = true
        render :new
      end
    end
  end

  def show
    @sidebar_tags = get_sidebar_tags(70)
    @last_hour_upvotes = @video.votes
                               .where("votes.value = 1 AND votes.created_at BETWEEN '#{1.hour.ago}' AND '#{Time.now}'")
                               .count
    @video_owner = @video.user
    @tag = @video.tag
    comments = @video.comments
                     .roots
                     .includes(:commentator)
                     .order(created_at: :desc)

    comments = comments.limit(6) unless params[:all_comments].present?
    @comments_tree = comments.map { |comment| comment.subtree(to_depth: 1).arrange }

    @vote = Vote.find_by(voter_id: current_user.id, video_id: @video.id) if current_user.present?
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

  private

  def find_video
    @video ||= Video.friendly.find(params[:video_slug])
  end

  def meta_title
    @meta_title = case action_name
                  when 'show'
                    [
                      "#{find_video.title} posted to #{find_video.user.channel_name}",
                      'flickbin',
                      'Discover and rank the best videos on the web.'
                    ]
                  else
                    super
    end
  end
end
