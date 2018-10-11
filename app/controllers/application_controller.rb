class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :get_tending_tags

  private

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end

  def get_tending_tags
    @trending_tags = Tag.order(rank: :asc) unless devise_controller?
  end
end
