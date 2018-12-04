class WaspPostService
  YOUTUBE_SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search'

  def call
    dummy_users = User.where(role: 'dummy')

    Tag.where(wasp_post: true).find_each do |tag|
      youtube_videos = get_youtube_videos(tag.title)

      youtube_videos['items'].each do |item|
        youtube_id = item.dig('id', 'videoId')
        title = item.dig('snippet', 'title')
        next if invalid_video?(tag.id, youtube_id, title)

        Video.create!(
          tag_id: tag.id,
          user_id: dummy_users.sample.id,
          url: "https://www.youtube.com/watch?v=#{youtube_id}"
        )

        break
      end
    end
  end

  private

  def invalid_video?(tag_id, youtube_id, title)
    Video.exists?(tag_id: tag_id, youtube_id: youtube_id) ||
      Video.exists?(tag_id: tag_id, title: title)
  end

  def get_youtube_videos(query)
    params = {
      part: 'snippet',
      type: 'video',
      key: ENV['YT_API_KEY'],
      maxResults: 50,
      order: 'relevance',
      publishedAfter: 7.days.ago.rfc3339,
      relevanceLanguage: 'en',
      pregionCode: 'US',
      eventType: 'completed',
      q: query
    }

    response_body = RestClient.get(YOUTUBE_SEARCH_URL, { params: params }).body
    JSON.parse(response_body)
  end
end
