class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :commentator_id
      t.integer :video_id
      t.integer :parent_id
      t.text :message

      t.timestamps
    end

    add_index :comments, [:video_id, :commentator_id]
    add_index :comments, :commentator_id
    add_index :comments, :parent_id
  end
end
