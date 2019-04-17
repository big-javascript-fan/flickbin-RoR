class RemoveVoicesFromBattle < ActiveRecord::Migration[5.1]
  def change
    remove_column :battles, :first_member_voices
    remove_column :battles, :second_member_voices
  end
end
