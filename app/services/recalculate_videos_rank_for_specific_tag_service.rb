# frozen_string_literal: true

class RecalculateVideosRankForSpecificTagService
  def initialize(tag)
    @tag = tag
    @tag_videos = @tag.videos.active.tagged.order(rank: :asc)
  end

  def call
    rank = 1

    @tag_videos.each do |video|
      video.update_attribute(:rank, rank)
      rank += 1
    end
  end
end
