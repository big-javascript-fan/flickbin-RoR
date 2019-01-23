class AddColimnKindOfToVideo < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :kind_of, :string, default: ''
  end
end
