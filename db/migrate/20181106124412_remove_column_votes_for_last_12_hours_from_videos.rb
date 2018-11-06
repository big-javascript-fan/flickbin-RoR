class RemoveColumnVotesForLast12HoursFromVideos < ActiveRecord::Migration[5.1]
  def change
    remove_column :videos, :votes_for_last_12_hours , :integer
  end
end
