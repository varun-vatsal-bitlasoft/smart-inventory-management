class User < ApplicationRecord
  has_secure_password


  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  belongs_to :department
  belongs_to :role_description
  
end
