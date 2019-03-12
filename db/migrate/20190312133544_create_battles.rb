class CreateBattles < ActiveRecord::Migration[5.1]
  def change
    create_table :battles do |t|
      t.integer :tag_id
      t.integer :first_member_id
      t.integer :second_member_id
      t.datetime :final_date
      t.string :status, default: 'active'

      t.timestamps
    end

    add_index :battles, :tag_id
  end
end
