class WaspPostService
  YOUTUBE_SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search'

  def call
    @dummy_users = User.where(role: 'dummy')

    Tag.where(wasp_post: true).find_each do |tag|
      youtube_videos = get_youtube_videos(tag.title)
      wasp_post_video(tag, youtube_videos)
    end
  end

  private

  def get_youtube_videos(query, nextPageToken = nil)
    params = {
      part: 'snippet',
      type: 'video',
      key: ENV['YT_API_KEY'],
      maxResults: 50,
      order: 'relevance',
      publishedAfter: 7.days.ago.rfc3339,
      videoEmbeddable: true,
      q: query
    }

    params.update(pageToken: nextPageToken) if nextPageToken.present?
    response_body = RestClient.get(YOUTUBE_SEARCH_URL, { params: params }).body
    JSON.parse(response_body)
  end

  def wasp_post_video(tag, youtube_videos)
    return if youtube_videos['items'].blank?

    youtube_videos['items'].each do |item|
      youtube_id = item.dig('id', 'videoId')
      title = item.dig('snippet', 'title')
      next if invalid_video?(tag.id, youtube_id, title)

      Video.create!(
        tag_id: tag.id,
        user_id: @dummy_users.sample.id,
        url: "https://www.youtube.com/watch?v=#{youtube_id}",
        wasp_post: true
      )

      return
    end

    nextPageToken = youtube_videos['nextPageToken']
    if nextPageToken.present?
      youtube_videos = get_youtube_videos(tag.title, nextPageToken)
      wasp_post_video(tag, youtube_videos)
    end
  end

  def invalid_video?(tag_id, youtube_id, title)
    Video.exists?(tag_id: tag_id, youtube_id: youtube_id) ||
      Video.exists?(tag_id: tag_id, title: title)
  end
end
