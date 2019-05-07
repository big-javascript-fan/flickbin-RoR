# frozen_string_literal: true

ActiveAdmin.register SystemSetting do
  menu priority: 1
  config.paginate = false
  config.filters = false
  permit_params :data
  json_editor

  form do |f|
    f.inputs do
      f.input :data, as: :json
    end
    f.actions
  end
end
