# frozen_string_literal: true

class Api::V1::ExceptionsController < Api::V1::BaseController
  def create
    ExceptionLogger.create(source: params[:source], message: params[:exception])
    AppConstants::JS_EXCEPTION_RECIPIENTS.each do |recipient|
      ApplicationMailer.notify_exception(recipient, params[:exception], params[:source]).deliver_later
    end
    head :ok
  end
end
