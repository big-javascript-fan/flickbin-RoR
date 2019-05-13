# frozen_string_literal: true

class UpdateUntaggedVideoService
  def call
    Video.active.tagged.find_each do |video|
      video.update_attribute(:untagged, true) if video.remaining_days <= 0
    end
  end
end
