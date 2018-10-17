class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :get_tending_tags

  private

  def render_error(status, type, messages)
    json = { type: type, messages: messages }
    render json: json, status: status
  end
end
