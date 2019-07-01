class CreateVoteIps < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_ips do |t|
      t.string  :ip

      t.timestamps
    end
  end
end
