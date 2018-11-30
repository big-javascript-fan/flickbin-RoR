class AddWaspOutreachColumnToVideo < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :wasp_outreach, :boolean, default: false
  end
end
