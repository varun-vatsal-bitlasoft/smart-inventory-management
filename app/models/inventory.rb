class Inventory < ApplicationRecord
  belongs_to :Product
  has_many :product_transactions
end