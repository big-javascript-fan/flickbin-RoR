# frozen_string_literal: true

class RecalculateTopContributorsService
  def call
    tag_ids = Tag.joins(:videos)
                 .where(videos: { removed: false })
                 .distinct
                 .pluck(:id)

    tag_ids.each { |tag_id| recalculate_contributors_rank(tag_id) }
  end

  private

  def recalculate_contributors_rank(tag_id)
    grouped_users = Video.where(tag_id: tag_id, removed: false)
                         .group(:user_id)
                         .sum('positive_votes_amount + 1')

    grouped_users.each do |user_id, amount|
      cp = ContributionPoint.find_or_initialize_by(tag_id: tag_id, user_id: user_id)
      cp.update(amount: amount)
    end
  end
end
