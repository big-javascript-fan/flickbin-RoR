class CreateSubscriptionsFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions_follows do |t|
      t.integer :subscription_id
      t.integer :follower_id

      t.timestamps
    end

    add_index :subscriptions_follows, :subscription_id
    add_index :subscriptions_follows, :follower_id
    add_index :subscriptions_follows, [:subscription_id, :follower_id], unique: true
  end
end
