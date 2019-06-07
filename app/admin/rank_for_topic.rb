# frozen_string_literal: true

ActiveAdmin.register RankForTopic, as: 'Ranc For Topic' do
  index do
    # id_column
    column :id do |rft|
      link_to rft.id, admin_tag_path(rft.id)
    end
    column :title
    column :rank
    column :video_count
    column :vote_count
  end

  filter :title
end
