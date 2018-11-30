class InsertInitDataToSystemSettings < ActiveRecord::Migration[5.1]
  def change
    Rake::Task['one_time_data_migration:system_settings'].invoke
  end
end
