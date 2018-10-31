class AddColumnVotesAmountToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :votes_amount, :integer, default: 0
  end
end
