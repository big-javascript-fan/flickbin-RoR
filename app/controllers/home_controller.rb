# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @sidebar_tags = get_sidebar_tags(70)
    @videos = Video.where(wasp_post: false).order('id desc').limit(20)
  end
end
