# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecalculateVideosRankForSpecificTagService do
  let!(:user) { create(:user) }
  let!(:tag) { create(:tag) }
  let!(:videos) { create_list(:video, 3, user: user, tag: tag) }

  it 'Switch first 2 videos to untagged and removed status and run videos rank recalculation for specific tag' do
    videos.first.update(untagged: true)
    videos.second.update(removed: true)

    RecalculateVideosRankForSpecificTagService.new(tag).call
    videos_sorted_by_rank = Video.active
                                 .tagged
                                 .where(tag_id: tag.id)
                                 .order(rank: :asc)

    expect(videos_sorted_by_rank.size).to eq(1)
    expect(videos_sorted_by_rank.last.rank).to eq(1)
    expect(videos_sorted_by_rank.last.id).to eq(videos.last.id)
  end
end
