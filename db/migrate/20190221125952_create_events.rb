class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.json :event_object
      t.string :category

      t.timestamps
    end
  end
end
