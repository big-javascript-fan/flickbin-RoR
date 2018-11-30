class CreateSystemSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :system_settings do |t|
      t.json :data

      t.timestamps
    end
  end
end
