class TagsController < ApplicationController
  def new
    @tag = Tag.new
  end

  def create
  end

  def index
    @sidebar_tags = get_sidebar_tags(70)
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
    @sidebar_tags = get_sidebar_tags
    @tag = Tag.friendly.find(params[:tag_slug])
    @tag_videos = Video.active
                       .tagged
                       .includes(:user)
                       .where(tag_id: @tag.id)
    @top_3_contribution_points = @tag.contribution_points
                                     .includes(:user)
                                     .where.not(users: { role: 'dummy', email: AppConstants::NOT_RATED_USER_EMAILS })
                                     .where('contribution_points.amount > ?', 0)
                                     .order(amount: :desc)
                                     .limit(3)

    @current_user_voted_video_ids = current_user.votes.map(&:video_id) if current_user.present?
    @tag_videos =
      if params[:sort_by] == 'newest'
        @tag_videos = @tag_videos.order(created_at: :desc).limit(10)
      else

        @tag_videos = @tag_videos.order(positive_votes_amount: :desc, rank: :asc, created_at: :desc).limit(10)
      end
  end
end
