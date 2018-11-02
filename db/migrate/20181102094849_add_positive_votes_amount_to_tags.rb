class AddPositiveVotesAmountToTags < ActiveRecord::Migration[5.1]
  def change
    rename_column :tags, :votes_amount, :positive_votes_amount
    add_column :tags, :negative_votes_amount, :integer, default: 0
  end
end
