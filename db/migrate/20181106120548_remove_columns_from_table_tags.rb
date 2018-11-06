class RemoveColumnsFromTableTags < ActiveRecord::Migration[5.1]
  def change
    remove_column :tags, :positive_votes_amount, :integer
    remove_column :tags, :negative_votes_amount, :integer
  end
end
