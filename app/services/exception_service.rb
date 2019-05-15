# frozen_string_literal: true

class ExceptionService < ApplicationService
  def initialize(args)
    @source = args.dig(:source)
    @message = args.dig(:message)
    @params = args.dig(:params)
    @env = args.dig(:env)
  end

  def call
    ExceptionLogger.create(
      source: @source,
      message: @message,
      params: @params
    )
    ExceptionNotifier.notify_exception(
      @message,
      env: @env,
      data: { source: @source }
    )
  end
end
