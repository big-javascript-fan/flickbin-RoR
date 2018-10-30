class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource

  private

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end

  def get_sidebar_tags(number_of_tags_per_page = 28)
    @sidebar_tags ||= Tag.order(rank: :asc).page(params[:page]).per(number_of_tags_per_page)
  end
end
