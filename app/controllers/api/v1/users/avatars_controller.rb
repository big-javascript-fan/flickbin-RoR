# frozen_string_literal: true

class Api::V1::Users::AvatarsController < Api::V1::BaseController
  before_action :authenticate_user!

  def update
    if current_user.update(avatar: update_params[:avatar])
      head :ok
    else
      render_error(422, 'NotValid', current_user.errors.messages)
    end
  end

  private

  def update_params
    params.fetch(:user, {}).permit(:avatar)
  end
end
