# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :find_tag, only: %i[show]
  before_action :load_videos, only: %i[show]
  before_action :load_top_3_contribution_points, only: %i[show]
  before_action :load_current_user_voted_video_ids, only: %i[show]
  before_action :load_sidebar_tags
  before_action :load_grouped_tags, only: %i[index]
  before_action :build_tag, only: %(new)

  def new; end

  def create; end

  def index; end

  def show; end

  private

  def build_tag
    @tag = Tag.new
  end

  def load_videos
    @tag_videos = Video.active
                       .tagged
                       .includes(:user)
                       .where(tag_id: @tag.id)

    @tag_videos = if params[:sort_by] == 'newest'
                    @tag_videos.order(created_at: :desc).limit(10)
                  else
                    @tag_videos.order(rank: :asc, positive_votes_amount: :desc, created_at: :desc).limit(10)
    end
  end

  def load_top_3_contribution_points
    @top_3_contribution_points = @tag.contribution_points
                                     .includes(:user)
                                     .where.not(users: { role: 'dummy', email: AppConstants::NOT_RATED_USER_EMAILS })
                                     .where('contribution_points.amount > ?', 0)
                                     .order(amount: :desc)
                                     .limit(3)
  end

  def load_current_user_voted_video_ids
    @current_user_voted_video_ids = current_user.votes.map(&:video_id) if current_user.present?
  end

  def find_tag
    @tag = Tag.friendly.find(params[:tag_slug])
  end

  def load_sidebar_tags
    @sidebar_tags = case action_name
                    when 'index'
                      get_sidebar_tags(70)
                    else
                      get_sidebar_tags
    end
  end

  def load_grouped_tags
    tags = Tag.order(first_character: :asc)
    tags = tags.where(first_character: params[:first_char]&.first) if params[:first_char].present?
    tags = tags.where('title ILIKE ?', "%#{params[:query]}%") if params[:query].present?
    @grouped_tags = tags.select(:id, :slug, :title, :first_character)
                        .limit(200)
                        .group_by(&:first_character)
  end

  def meta_title
    @meta_title = case action_name
                  when 'show'
                    [
                      "#{find_tag.title} on flickbin.tv",
                      'Discover and rank the best videos on the web.'
                    ]
                  else
                    super
    end
  end
end
