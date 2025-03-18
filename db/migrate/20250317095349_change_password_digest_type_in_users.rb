class ChangePasswordDigestTypeInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :password_digest, :string
  end
end
