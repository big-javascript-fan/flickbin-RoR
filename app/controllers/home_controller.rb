class HomeController < ApplicationController
  def index
    @sidebar_tags = get_sidebar_tags
    @top_1_tag = @sidebar_tags.includes(:top_10_videos).first
    @top_2_tag = @sidebar_tags.includes(:top_10_videos).second
    @top_3_tag = @sidebar_tags.includes(:top_10_videos).third
    @top_4_tag = @sidebar_tags.includes(:top_10_videos).fourth
  end

  private

  def get_sidebar_tags
    @sidebar_tags ||= Tag.order(rank: :asc).limit(56)
  end
end
