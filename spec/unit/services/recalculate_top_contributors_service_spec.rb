# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecalculateTopContributorsService do
  let!(:users) { create_list(:user, 11) }
  let!(:tag) { create(:tag) }
  let!(:user_ids) { users.pluck(:id) }

  context 'Create videos for tag' do
    before do
      ActionMailer::Base.deliveries = []

      users.each_with_index do |user, index|
        create_list(:video, index + 1, user: user, tag: tag)
      end
    end

    it 'Run top contributors recalculation' do
      RecalculateTopContributorsService.new.call
      sorted_user_ids = tag.contribution_points.order(amount: :desc).map(&:user_id)

      expect(Notification.count).to eq(10)
      expect(Notification.where(category: 'top_1_contributor').size).to eq(1)
      expect(Notification.where(category: 'top_3_contributors').size).to eq(2)
      expect(Notification.where(category: 'top_5_contributors').size).to eq(2)
      expect(Notification.where(category: 'top_10_contributors').size).to eq(5)

      expect(Notification.where(category: 'top_1_contributor').map(&:user_id)).to eq([sorted_user_ids.first])
      expect(Notification.where(category: 'top_3_contributors').map(&:user_id)).to eq(sorted_user_ids[1..2])
      expect(Notification.where(category: 'top_5_contributors').map(&:user_id)).to eq(sorted_user_ids[3..4])
      expect(Notification.where(category: 'top_10_contributors').map(&:user_id)).to eq(sorted_user_ids[5..9])

      expect(ApplicationMailer.deliveries.count).to eq(10)
      expect(ApplicationMailer.deliveries.map(&:to).flatten).to eq(users.reverse.map(&:email)[0..9])
      expect(ApplicationMailer.deliveries[0].subject).to eq("You're now the top contributor!")
      expect(ApplicationMailer.deliveries[1].subject).to eq("You're now one of the top 3 contributors")
      expect(ApplicationMailer.deliveries[2].subject).to eq("You're now one of the top 3 contributors")
      expect(ApplicationMailer.deliveries[3].subject).to eq("You're now in the top 5")
      expect(ApplicationMailer.deliveries[4].subject).to eq("You're now in the top 5")
      expect(ApplicationMailer.deliveries[5].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[6].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[7].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[8].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[9].subject).to eq("You're in the running for top contributor")

      expect(sorted_user_ids).to eq(user_ids.reverse)
    end

    it 'Update positive_votes_amount for video for contributor number 11 and run top contributors recalculation' do
      RecalculateTopContributorsService.new.call
      users.first.videos.first.update(positive_votes_amount: 100)
      RecalculateTopContributorsService.new.call
      sorted_user_ids = tag.contribution_points.order(amount: :desc).map(&:user_id)

      expect(Notification.count).to eq(14)
      expect(Notification.where(category: 'top_1_contributor').size).to eq(2)
      expect(Notification.where(category: 'top_3_contributors').size).to eq(3)
      expect(Notification.where(category: 'top_5_contributors').size).to eq(3)
      expect(Notification.where(category: 'top_10_contributors').size).to eq(6)

      expect(ApplicationMailer.deliveries.count).to eq(14)
      expect(ApplicationMailer.deliveries[0].subject).to eq("You're now the top contributor!")
      expect(ApplicationMailer.deliveries[1].subject).to eq("You're now one of the top 3 contributors")
      expect(ApplicationMailer.deliveries[2].subject).to eq("You're now one of the top 3 contributors")
      expect(ApplicationMailer.deliveries[3].subject).to eq("You're now in the top 5")
      expect(ApplicationMailer.deliveries[4].subject).to eq("You're now in the top 5")
      expect(ApplicationMailer.deliveries[5].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[6].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[7].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[8].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[9].subject).to eq("You're in the running for top contributor")
      expect(ApplicationMailer.deliveries[10].subject).to eq("You're now the top contributor!")
      expect(ApplicationMailer.deliveries[11].subject).to eq("You're now one of the top 3 contributors")
      expect(ApplicationMailer.deliveries[12].subject).to eq("You're now in the top 5")
      expect(ApplicationMailer.deliveries[13].subject).to eq("You're in the running for top contributor")

      expect(sorted_user_ids).to eq(user_ids.insert(-1, user_ids.delete_at(0)).reverse)
    end
  end
end
