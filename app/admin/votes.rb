# frozen_string_literal: true

ActiveAdmin.register Vote do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  config.filters = false

  index pagination_total: false do
    selectable_column
    id_column
    column :value
    column :video
    column :voter do |vote|
      auto_link(vote, vote.voter_id)
    end
    column :created_at
    column :updated_at
    actions
  end
end
