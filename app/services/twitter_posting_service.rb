class TwitterPostingService
  include Rails.application.routes.url_helpers

  def initialize(video_id)
    default_url_options[:host] = ActionMailer::Base.asset_host
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
    case Rails.env
    when 'production', 'staging'
      video_url = video_url(@video)
    else
      video_url = video_url(@video.id)
    end

    "Currently Trending in #{@tag.title.capitalize} on flickbin - Upvote Now!: \"#{@video.title}\" video by: @#{@video.twitter_handle} #{video_url}"
  end
end