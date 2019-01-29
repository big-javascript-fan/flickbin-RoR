class Api::V1::SocialNetworksController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create]

  def index
    case params[:source]
    when 'youtube'
      YoutubeAdditionalDataService.new(self).call
    when 'facebook'
      FacebookAdditionalDataService.new(self).call
    when 'twitch'
      TwitchAdditionalDataService.new(self).call
    when 'daily_motion'
      DailyMotionAdditionalDataService.new(self).call
    else
      self.errors.add(:invalid_url, 'Video url invalid')
    end

    render json: tags.to_json(only: [:id, :slug, :title])
  end
end
