class CreateBattles < ActiveRecord::Migration[5.1]
  def change
    create_table :battles do |t|
      t.integer  :tag_id
      t.integer  :first_member_id
      t.integer  :second_member_id
      t.integer  :first_member_voices
      t.integer  :second_member_voices
      t.integer  :number_of_rematch_requests
      t.string   :winner
      t.string   :status, default: 'live'
      t.datetime :final_date

      t.timestamps
    end

    add_index :battles, :tag_id
  end
end
