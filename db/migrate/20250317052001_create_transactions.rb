class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :size
      t.date :transaction_date
      t.integer :price
      t.boolean :in_going
      t.references :product, null: false, foreign_key: true
      t.references :inventory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
