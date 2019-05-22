class AddHighQualityCoverToVideoTable < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :high_quality_cover, :boolean, default: false
  end
end
