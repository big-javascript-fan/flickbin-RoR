# frozen_string_literal: true

ActiveAdmin.register Event do
  # filter :user_id, label: 'User Email', as: :search_select_filter, fields: [:email], display_name: 'email'
  # filter :category, as: :select, collection: proc { Notification::CATEGORIES }
end
