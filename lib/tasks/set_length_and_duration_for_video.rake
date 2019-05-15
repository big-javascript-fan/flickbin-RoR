# frozen_string_literal: true

namespace :set_length_and_duration_for_video do
  desc 'Import length and duration from YouTube'
  # example of task launch - rake set_length_and_duration_for_video:import
  task import: :environment do
    Video.where(source: 'youtube', length: nil, duration: nil).find_each do |video|
      youtube_video = SocialNetworks::YoutubeApiService.new(video.source_id).call
      length = youtube_video.dig(:length)
      duration = youtube_video.dig(:duration)

      unless length.nil? && duration.nil?
        puts "video #{video.title} - updated".green if video.update(
          length: length,
          duration: duration
        )
      end
    rescue StandardError => e
      puts e.to_s.red
    end
  end
end
