class CreateRematchRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :rematch_requests do |t|
      t.references :battle
      t.references :user
      t.string :ip

      t.timestamps
    end
  end
end
