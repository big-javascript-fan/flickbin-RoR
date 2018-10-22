class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :video_id
      t.integer :voter_id

      t.timestamps
    end

    add_index :votes, [:video_id, :voter_id], unique: true
    add_index :votes, :video_id
  end
end
