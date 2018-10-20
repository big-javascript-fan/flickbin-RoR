class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :user_id
      t.integer :voter_id

      t.timestamps
    end

    add_index :votes, [:voter_id, :user_id], unique: true
    add_index :votes, :user_id
  end
end
