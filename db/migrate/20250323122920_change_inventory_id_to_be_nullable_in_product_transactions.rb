class ChangeInventoryIdToBeNullableInProductTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :product_transactions, :inventory_id, true
  end
end
