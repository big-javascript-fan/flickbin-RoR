# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :load_sidebar_tags
  before_action :find_user, only: %(show)
  before_action :load_user_videos, only: %(show)

  def show; end

  private

  def load_sidebar_tags
    @sidebar_tags ||= get_sidebar_tags
  end

  def find_user
    @user ||= User.friendly.find(params[:channel_slug])
  end

  def load_user_videos
    @user_videos = Video.includes(:tag)
                        .active
                        .where(user_id: @user.id)
                        .order(created_at: :desc)
                        .limit(10)
  end

  def meta_title
    @meta_title = case action_name
                  when 'show'
                    [
                      "#{find_user.channel_name} on flickbin",
                      'Discover and rank the best videos on the web.'
                    ]
                  else
                    super
    end
  end
end
