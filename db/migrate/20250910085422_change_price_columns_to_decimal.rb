class ChangePriceColumnsToDecimal < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :in_price, :decimal, precision: 10, scale: 2
    change_column :products, :out_price, :decimal, precision: 10, scale: 2
  end
end
