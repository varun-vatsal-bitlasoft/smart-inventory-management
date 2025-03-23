class Inventory < ApplicationRecord
  belongs_to :product
  has_many :product_transactions, dependent: :nullify
end