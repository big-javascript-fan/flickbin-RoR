class AddUserIdToVoteIps < ActiveRecord::Migration[5.1]
  def change
    change_table :vote_ips do |t|
      t.references :user
    end
  end
end
