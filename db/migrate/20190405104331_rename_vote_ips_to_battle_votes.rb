class RenameVoteIpsToBattleVotes < ActiveRecord::Migration[5.1]
  def change
    rename_table :vote_ips, :battle_votes
    add_reference :battle_votes, :battle_member
  end
end
