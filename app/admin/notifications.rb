ActiveAdmin.register Notification do
  # permit_params :user_id, :category

  filter :user_id, as: :search_select_filter, fields: [:email], display_name: 'email'#, collection: proc { User.all.map { |u| [u.email, u.id] } }
  filter :category, as: :select, collection: proc { Notification::CATEGORIES }
end
