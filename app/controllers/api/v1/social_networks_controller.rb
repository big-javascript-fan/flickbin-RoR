# frozen_string_literal: true

class Api::V1::SocialNetworksController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:index]

  def index
    api_data = get_api_data(params)

    if api_data[:error].present?
      render json: api_data
    elsif params[:source] == 'youtube' && api_data[:embeddable].blank?
      render json: { error: 'This video cannot be embedded.' }
    elsif params[:source] == 'twitch' && api_data[:type] == 'stream' && api_data[:stream_available].blank?
      render json: { error: 'This stream is not available to embed.' }
    elsif params[:source] == 'dailymotion' && api_data[:channel].blank?
      render json: { error: 'Video encoding is in progress. This video cannot be embedded.' }
    else
      render json: api_data
    end
  end

  private

  def get_api_data(params)
    case params[:source]
    when 'youtube'
      video_id = VideoHelper.get_video_id_form_youtube_url(params[:video_url])
      if video_id.present?
        SocialNetworks::YoutubeApiService.new(video_id).call
      else
        { error: 'Invalid youtube video url' }
      end
    when 'facebook'
      video_id = VideoHelper.get_video_id_form_facebook_url(params[:video_url])
      if video_id.present?
        SocialNetworks::FacebookApiService.new(video_id).call
      else
        { error: 'Invalid facebook video url' }
      end
    when 'twitch'
      video_id, type = VideoHelper.get_video_id_with_type_from_twitch_url(params[:video_url]).values
      if video_id.present? && type.present?
        SocialNetworks::TwitchApiService.new(video_id, type).call
      else
        { error: 'Invalid twitch video url' }
      end
    when 'dailymotion'
      video_id = VideoHelper.get_video_id_form_daily_motion_url(params[:video_url])
      if video_id.present?
        SocialNetworks::DailyMotionApiService.new(video_id).call
      else
        { error: 'Invalid daily motion video url' }
      end
    else
      { error: 'Video url invalid' }
    end
  rescue StandardError => e
    # ExceptionLogger.create(source: 'Api::V1::SocialNetworksController#index', message: e, params: params)
    ExceptionNotifier.notify_exception(e, env: request.env, data: { source: 'Api::V1::SocialNetworksController#index' })
    { error: 'Video url invalid' }
  end
end
