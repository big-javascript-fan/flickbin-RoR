# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :prepare_exception_notifier
  before_action :meta_title
  layout :layout_by_resource

  private

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: current_user&.to_json
    }
  end

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end

  def get_sidebar_tags(number_of_tags_per_page = 35)
    @sidebar_tags ||= Tag.order(rank: :asc, created_at: :desc).page(params[:page]).per(number_of_tags_per_page)
  end

  def after_sign_in_path_for(_resource)
    if params[:video_id].present? && params[:event] == 'comment'
      video_path(params[:video_id], anchor: 'message')
    elsif params[:video_id].present? && params[:event] == 'vote'
      video_path(params[:video_id], anchor: 'voting_button')
    else
      root_path
    end
  end

  def meta_title
    @meta_title ||= [
      'flickbin',
      'Discover and rank the best videos on the web.'
    ]
  end
end
