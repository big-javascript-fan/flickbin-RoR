class AddSlugToBattles < ActiveRecord::Migration[5.1]
  def change
    add_column :battles, :slug, :string
    add_index :battles, :slug, unique: true

    Battle.find_each(&:save)
  end
end
