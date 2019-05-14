# frozen_string_literal: true

namespace :update_cover_for_video do
  desc 'for youtube'
  task youtube: :environment do
    Video.where(source: 'youtube').each do |video|
      cover_url = SocialNetworks::YoutubeApiService.new(video.source_id)
                                                   .call
                                                   .dig(:remote_cover_url)
      video.update(
        remote_cover_url: cover_url
      )
      puts "video #{video.title} - updated".green
    rescue StandardError => e
      puts e.to_s.red
    end
  end

  desc 'for twitch'
  task twitch: :environment do
    Video.where(source: 'twitch').each do |video|
      cover_url = SocialNetworks::TwitchApiService.new(video.source_id, video.kind_of)
                                                  .call
                                                  .dig(:remote_cover_url)
      video.update(
        remote_cover_url: cover_url
      )
      puts "video #{video.title} - updated".green
    rescue StandardError => e
      puts e.to_s.red
    end
  end
end
