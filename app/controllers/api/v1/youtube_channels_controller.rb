# frozen_string_literal: true

class Api::V1::YoutubeChannelsController < Api::V1::BaseController
  def index
    url = params[:youtube_channel_url]
    data = get_data_from_youtube_page(url)
    render json: data
  end

  private

  def get_data_from_youtube_page(url)
    # Nokogiri doesn't see element ids from Youtube pages because they are loading by AJAX after page loaded
    response_body = RestClient.get(url).body
    doc = Nokogiri::HTML(response_body)
    twitter_account_name = doc.at_css('a[title="Twitter"]')&.attr('href')&.split('/')&.last
    name = doc.at_css('img.appbar-nav-avatar').attr('title')
    photo_url = doc.at_css('link[rel=image_src]').attr('href')

    {
      name: name,
      photo_url: photo_url,
      twitter_account_name: twitter_account_name
    }
  end
end
