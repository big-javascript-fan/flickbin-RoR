# frozen_string_literal: true

ActiveAdmin.register Notification do
  # permit_params :user_id, :category

  filter :user_id, label: 'User Email', as: :search_select_filter, fields: [:email], display_name: 'email'
  filter :category, as: :select, collection: proc { Notification::CATEGORIES }
end
