ActiveAdmin.register Tag do
  permit_params :wasp_post
  config.sort_order = 'wasp_post_desc'

  index do
    selectable_column
    id_column
    column :title
    toggle_bool_column 'WASP Post', :wasp_post
    column :created_at
    column :updated_at
    actions
  end

  filter :wasp_post
end
