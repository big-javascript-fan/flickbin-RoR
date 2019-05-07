# frozen_string_literal: true

namespace :one_time_data_migration do
  desc 'Import setting from yml file to DB table system_settings'
  # example of task launch - rake one_time_data_migration:system_settings
  task system_settings: :environment do
    settings_data = YAML.load_file("#{Rails.root}/config/data/system_settings.yml")
    setting = SystemSetting.first_or_initialize
    setting.update!(data: settings_data)
    puts 'Importing system settings was successful'.green
  rescue StandardError => e
    puts e.to_s.red
  end
end
