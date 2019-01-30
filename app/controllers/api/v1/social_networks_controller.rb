class Api::V1::SocialNetworksController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:index]

  def index
    api_data =
    case params[:source]
      when 'youtube'
        video_id = VideoHelper.get_video_id_form_youtube_url(params[:video_url])
        if video_id.present?
          SocialNetworks::YoutubeApiService.new(video_id).call
        else
          { error: 'invalid youtube video url'}
        end
      when 'facebook'
        video_id = VideoHelper.get_video_id_form_facebook_url(params[:video_url])
        if video_id.present?
          SocialNetworks::FacebookApiService.new(video_id).call
        else
          { error: 'invalid facebook video url'}
        end
      when 'twitch'
        video_id, type = VideoHelper.get_video_id_with_type_from_twitch_url(params[:video_url]).values
        if video_id.present? && type.present?
          SocialNetworks::TwitchApiService.new(video_id, type).call
        else
          { error: 'invalid twitch video url'}
        end
      when 'daily_motion'
        video_id = VideoHelper.get_video_id_form_daily_motion_url(params[:video_url])
        if video_id.present?
          SocialNetworks::DailyMotionApiService.new(video_id).call
        else
          { error: 'invalid daily motion video url'}
        end
      else
        { error: 'invalid social network source'}
    end

    render json: api_data
  end
end
