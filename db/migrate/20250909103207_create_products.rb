class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :description
      t.integer :in_price
      t.integer :out_price
      t.string :size
      t.string :prod_code
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
