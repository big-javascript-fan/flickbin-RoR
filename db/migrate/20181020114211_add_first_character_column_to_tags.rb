class AddFirstCharacterColumnToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :first_character, :string, default: ''
    add_index :tags, :first_character
  end
end
