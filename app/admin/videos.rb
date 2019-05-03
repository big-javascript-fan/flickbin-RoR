# frozen_string_literal: true

ActiveAdmin.register Video do
  permit_params :url, :tag_id
end
