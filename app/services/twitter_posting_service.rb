class TwitterPostingService
  def initialize(video_id)
    @video = Video.find(video_id)
    @tag = @video.tag
  end

  def call
    return if ENV['BUFFER_ACCESS_TOKEN'].blank?

    client = Buffer::Client.new(ENV['BUFFER_ACCESS_TOKEN'])
    client.create_update(
      body: {
        text: message_builder,
        profile_ids: [ENV['BUFFER_TWITTER_PROFILE_ID']],
        now: true
      }
    )
  end

  private

  def message_builder
    "Currently Trending in #{@tag.title.capitalize} on flickbin - Upvote Now!: \"#{@video.title}\" video by: @#{@video.twitter_handle} #{@video.url}"
  end
end
