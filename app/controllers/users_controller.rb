class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:channel_slug])
  end
end
