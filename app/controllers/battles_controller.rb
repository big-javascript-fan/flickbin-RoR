class BattlesController < ApplicationController
  def show
    @sidebar_tags = get_sidebar_tags(70)
    @tag = Tag.friendly.find(params[:tag_slug])
    @battle = @tag.battles.last
  end
end
