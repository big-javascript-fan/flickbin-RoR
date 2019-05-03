# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :allowed_to_send_notifications

  index do
    selectable_column
    id_column
    # column :email
    toggle_bool_column :allowed_to_send_notifications
    column :role do |user|
      case user.role
      when 'dummy'
        status_tag(user.role, :orange)
      when 'client'
        status_tag(user.role, :yes)
      when 'sidekiq_manager'
        status_tag(user.role, :red)
      else
        status_tag(user.role, :gray)
      end
    end
    column :channel_name
    column :rank
    column :confirmation_token
    column :confirmed_at
    column :confirmation_sent_at
    column :created_at
    column :updated_at
    actions
  end

  filter :email
end
