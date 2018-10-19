class Api::V1::Users::AvatarsController < Api::V1::BaseController
  before_action :authenticate_user!

  def update
    current_user.update_attribute(:avatar, update_params[:avatar])
    head :ok
  end

  private

  def update_params
    params.fetch(:user, {}).permit(:avatar)
  end
end
