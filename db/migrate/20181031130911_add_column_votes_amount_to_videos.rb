class AddColumnVotesAmountToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :votes_amount, :integer, default: 0
  end
end
