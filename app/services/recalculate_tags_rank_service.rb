class RecalculateTagsRankService
  def call
    rank = 1

    Tag.order(votes_amount: :desc).find_each do |tag|
      tag.update_attribute(:rank, rank)
      rank += 1
    end
  end
end
