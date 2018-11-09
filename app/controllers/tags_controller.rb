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
    @tag_videos = Video.active.tagged.where(tag_id: @tag.id)

    @tag_videos =
      if params[:sort_by] == 'newest'
        @tag_videos = @tag_videos.order(created_at: :desc).limit(10)
      else
        @tag_videos = @tag_videos.order(rank: :asc, created_at: :desc).limit(10)
      end
  end
end
