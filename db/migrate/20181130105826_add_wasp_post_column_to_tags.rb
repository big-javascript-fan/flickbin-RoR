class AddWaspPostColumnToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :wasp_post, :boolean, default: false
  end
end
