class RecalculateTagsRankService
  def call
    rank = 1

    Tag.order(votes_amount: :desc).each do |tag|
      penalty = tag.videos.active.count.zero? ? 1000 : 0

      tag.update_attribute(:rank, rank + penalty)
      rank += 1
    end
  end
end
