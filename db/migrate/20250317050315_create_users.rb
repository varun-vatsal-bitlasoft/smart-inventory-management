class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.text :password
      t.string :email
      t.integer :mobile
      t.references :department, null: false, foreign_key: true
      t.references :role_description, null: false, foreign_key: true

      t.timestamps
    end
  end
end
