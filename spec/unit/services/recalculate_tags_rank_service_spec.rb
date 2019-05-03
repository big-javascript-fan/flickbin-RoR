# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecalculateTagsRankService do
  let!(:user) { create(:user) }
  let!(:tags) { create_list(:tag, 10) }

  context 'Create videos for each tag' do
    before do
      tags.each_with_index do |tag, index|
        create_list(:video, index + 1, user: user, tag: tag)
      end
    end

    it 'Run tags rank recalculation' do
      RecalculateTagsRankService.new.call
      tags_sorted_by_rank = Tag.order(rank: :asc)

      expect(tags_sorted_by_rank.map(&:id)).to eq(tags.reverse.map(&:id))
    end

    it 'Vote for all videos from second tag by rank and run tags rank recalculation' do
      RecalculateTagsRankService.new.call
      Tag.order(rank: :asc).second.videos.each do |video|
        video.votes.create(voter_id: user.id, value: 1)
      end

      RecalculateTagsRankService.new.call
      tags_sorted_by_rank = Tag.order(rank: :asc)

      expect(tags_sorted_by_rank.first.id).to eq(tags.reverse.second.id)
    end

    it 'Create expired votes all videos from second tag by rank and run tags rank recalculation' do
      RecalculateTagsRankService.new.call
      Tag.order(rank: :asc).second.videos.each do |video|
        video.votes.create(voter_id: user.id, value: 1, created_at: 13.hours.ago)
      end

      RecalculateTagsRankService.new.call
      tags_sorted_by_rank = Tag.order(rank: :asc)

      expect(tags_sorted_by_rank.map(&:id)).to eq(tags.reverse.map(&:id))
    end
  end
end
