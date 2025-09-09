class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.string :description
      t.string :stock_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
