# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::BaseController
  def index
    sidebar_tags = get_sidebar_tags
    offset = params[:offset]&.to_i
    videos = Video::ObjectsForHomePageQuery.call(limit: 10, offset: offset)
    render json: Api::V1::Home::IndexSerializer.new(sidebar_tags, videos).call
  end
end
