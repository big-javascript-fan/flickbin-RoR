# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_error(status, type, messages)
    json = { type: type, messages: messages }
    render json: json, status: status
  end

  def render_not_found(error)
    message = I18n.t('errors.messages.not_found', klass: error.model, id: error.id)
    render_error(404, 'NotFound', record: [message])
  end
end
