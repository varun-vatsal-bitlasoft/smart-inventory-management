class RenameTransactionsToProductTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_table :transactions, :product_transactions
  end
end
