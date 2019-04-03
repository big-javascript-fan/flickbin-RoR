class AddDefaultValueToBattle < ActiveRecord::Migration[5.1]
  def change
    change_column_default :battles, :number_of_rematch_requests, 0
    change_column_default :battles, :first_member_voices, 0
    change_column_default :battles, :second_member_voices, 0 
    change_column_default :battles, :winner, ""
  end
end
