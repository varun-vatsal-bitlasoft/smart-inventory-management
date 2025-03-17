class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.integer :size
      t.date :expiry
      t.integer :price
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
