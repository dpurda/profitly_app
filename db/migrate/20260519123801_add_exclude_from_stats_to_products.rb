class AddExcludeFromStatsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :exclude_from_stats, :boolean, default: false, null: false
  end
end
