class HomeController < ApplicationController
  def index
    @top_1_tag = @trending_tags.includes(:top_10_videos).first
    @top_2_tag=  @trending_tags.includes(:top_10_videos).second
  end
end
