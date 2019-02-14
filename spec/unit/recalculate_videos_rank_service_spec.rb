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

    RecalculateVideosRankService.new.call
    videos_sort_by_rank = Video.active
                               .tagged
                               .where(tag_id: tag.id)
                               .order(rank: :asc)

    expect(user.notifications.first.category).to eq('top_1_video_in_tag')
    expect(user.notifications.second.category).to eq('top_10_videos_in_tag')
    expect(user.notifications.count).to eq(2)

    expect(ApplicationMailer.deliveries.first.subject).to eq("Your post is #1 in #{tag.title}!")
    expect(ApplicationMailer.deliveries.second.subject).to eq("Your post is now top ten in the #{tag.title} tag.")
    expect(ApplicationMailer.deliveries.count).to eq(2)

    expect(videos.map(&:id)).to eq(videos_sort_by_rank.reverse.map(&:id))
  end
end
