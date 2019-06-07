class CreateRankForTopics < ActiveRecord::Migration[5.1]
  def change
    create_view :rank_for_topics
  end
end
