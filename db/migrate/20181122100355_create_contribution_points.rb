class CreateContributionPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :contribution_points do |t|
      t.integer :tag_id
      t.integer :user_id
      t.integer :amount

      t.timestamps
    end

    add_index :contribution_points, [:user_id, :tag_id]
    add_index :contribution_points, :tag_id
    add_index :contribution_points, [:tag_id, :amount]
    add_index :contribution_points, :amount
  end
end
