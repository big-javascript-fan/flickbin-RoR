# frozen_string_literal: true

ActiveAdmin.register Comment, as: 'VideoComment' do
  config.filters = false

  index pagination_total: false do
    selectable_column
    id_column
    column :message
    column :commentator do |comment|
      auto_link(comment, comment.commentator_id)
    end
    column :created_at
    column :updated_at
    actions
  end
end
