# frozen_string_literal: true

class TvController < ApplicationController
  layout 'application'

  def index
    @tv_props = { channels: [] }

    User.limit(10).each do |user|
        user_videos = Video.includes(:tag)
                           .active
                           .where(user_id: user.id)
                           .order(created_at: :desc)
                           .limit(10)
        @tv_props[:channels] << { user: user, playlist: user_videos} unless user_videos.empty?
    end
  end
end
