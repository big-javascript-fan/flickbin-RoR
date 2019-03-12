ActiveAdmin.register Battle do
  permit_params :tag_id, :final_date, :first_member_id, :second_member_id, :status

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :tag
      f.input :first_member_id, as: :search_select, url: admin_users_path,
                    fields: [:channel_name], display_name: :channel_name, minimum_input_length: 3,
                    order_by: 'channel_name_asc'
      f.input :second_member_id, as: :search_select, url: admin_users_path,
                    fields: [:channel_name], display_name: :channel_name, minimum_input_length: 3,
                    order_by: 'channel_name_asc'
      f.input :status, as: :select, collection: Battle::STATUSES
    end
    f.actions
  end

  filter :tag
end
