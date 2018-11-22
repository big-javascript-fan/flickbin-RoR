class RecalculateTopContributorsService
  def call
    Tag.find_each do |tag|
      User.includes(accounting_videos: :tag).where(tags: { id: tag.id }).each do |user|
        amount = 0

        user.accounting_videos.each do |video|
          amount += (video.positive_votes_amount + 1)
        end

        cp = ContributionPoint.find_or_initialize_by(tag_id: tag.id, user_id: user.id)
        cp.update(amount: amount)
      end
    end
  end
end
