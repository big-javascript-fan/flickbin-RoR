class BattlesController < ApplicationController
  def index
    @sidebar_tags = get_sidebar_tags(70)
  end
end
