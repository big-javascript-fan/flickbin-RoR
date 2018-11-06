class AddColumnVotesForLast12HoursToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :votes_for_last_12_hours , :integer, default: 0
  end
end
