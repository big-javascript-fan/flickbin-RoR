class Api::V1::ExceptionsController < Api::V1::BaseController
  def create
    ExceptionLogger.create(source: params[:source], message: params[:exception])
    ApplicationMailer.notify_exception(params[:exception], params[:source]).deliver_later
    head :ok
  end
end
