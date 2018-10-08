class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :title
      t.integer :rank

      t.timestamps
    end

    add_index :tags, :title
    add_index :tags, :rank
  end
end
