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
    twitter_account_link = doc.at_css('a[title="Twitter"]').attr('href')
    channel_title = doc.at_css('img.appbar-nav-avatar').attr('title')
    channel_avatar_url = doc.at_css('img.appbar-nav-avatar').attr('src')
    twitter_account = twitter_account_link.split('/').last

    {
      channel_title: channel_title,
      channel_avatar_url: channel_avatar_url,
      twitter_account: twitter_account
    }
  end
end
