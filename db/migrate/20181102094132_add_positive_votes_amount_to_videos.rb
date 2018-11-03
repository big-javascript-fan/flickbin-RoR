class AddPositiveVotesAmountToVideos < ActiveRecord::Migration[5.1]
  def change
    rename_column :videos, :votes_amount, :positive_votes_amount
    add_column :videos, :negative_votes_amount, :integer, default: 0
  end
end
