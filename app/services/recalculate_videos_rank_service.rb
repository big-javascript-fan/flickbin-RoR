class RecalculateVideosRankService
  def call
    Tag.find_each do |tag|
      rank = 1

      tag.videos.order(votes_amount: :desc).find_each do |video|
        video.update_attribute(:rank, rank)
        rank += 1
      end
    end
  end
end
