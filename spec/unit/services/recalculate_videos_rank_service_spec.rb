# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecalculateVideosRankService do
  let!(:user) { create(:user) }
  let!(:tag) { create(:tag) }
  let!(:videos) { create_list(:video, 11, user: user, tag: tag) }

  before do
    ActionMailer::Base.deliveries = []
  end

  it 'Vote for videos and run videos rank recalculation' do
    videos.each_with_index do |video, index|
      index.times { video.votes.create(voter_id: user.id, value: 1) }
    end

    10.times { videos.first.votes.create(voter_id: user.id, value: 1, created_at: 8.days.ago) }
    RecalculateVideosRankService.new.call
    videos_sorted_by_rank = Video.active
                                 .tagged
                                 .where(tag_id: tag.id)
                                 .order(rank: :asc)

    expect(user.notifications.first.category).to eq('top_1_video_in_tag')
    expect(user.notifications.second.category).to eq('top_10_videos_in_tag')
    expect(user.notifications.count).to eq(2)

    expect(ApplicationMailer.deliveries.first.subject).to eq("Your post is #1 in #{tag.title}!")
    expect(ApplicationMailer.deliveries.second.subject).to eq("Your post is now top ten in the #{tag.title} tag.")
    expect(ApplicationMailer.deliveries.count).to eq(2)
    expect(videos.map(&:id)).to eq(videos_sorted_by_rank.reverse.map(&:id))
  end

  it 'Switch first video to untagged status and run videos rank recalculation' do
    videos.first.update(untagged: true)
    RecalculateVideosRankService.new.call
    videos_sorted_by_rank = Video.active
                                 .tagged
                                 .where(tag_id: tag.id)
                                 .order(rank: :asc)

    expect(videos_sorted_by_rank.size).to eq(videos.size - 1)
    expect(videos_sorted_by_rank.map(&:id)).to eq(videos.reverse.map(&:id) - [videos.first.id])
  end

  it 'Switch first video to removed status and run videos rank recalculation' do
    videos.first.update(removed: true)
    RecalculateVideosRankService.new.call
    videos_sorted_by_rank = Video.active
                                 .tagged
                                 .where(tag_id: tag.id)
                                 .order(rank: :asc)

    expect(videos_sorted_by_rank.size).to eq(videos.size - 1)
    expect(videos_sorted_by_rank.map(&:id)).to eq(videos.reverse.map(&:id) - [videos.first.id])
  end
end
