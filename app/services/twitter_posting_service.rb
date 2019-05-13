# frozen_string_literal: true

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
        media: { photo: @video.cover.url },
        profile_ids: [ENV['BUFFER_TWITTER_PROFILE_ID']]
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

    "Currently \#3 and rising in \##{@tag.title.capitalize} on flickbin - RT/Upvote Now!: \"#{@video.title}\" video by: @#{@video.twitter_handle} #{video_url} - \#video \#youtube \#videos \#youtubers"
  end
end
