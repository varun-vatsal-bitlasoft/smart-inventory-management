class Product < ApplicationRecord
  has_many_attached :images

  belongs_to :department
  has_many :product_transactions
  has_many :inventories

end
