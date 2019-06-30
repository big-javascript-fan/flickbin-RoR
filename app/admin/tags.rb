# frozen_string_literal: true

ActiveAdmin.register Tag do

  index do
    selectable_column
    id_column
    column :title
    column :created_at
    column :updated_at
    actions
  end

  filter :title
end
