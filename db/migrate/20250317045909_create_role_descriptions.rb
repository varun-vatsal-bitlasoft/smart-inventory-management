class CreateRoleDescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :role_descriptions do |t|
      t.string :name
      t.text :privilege

      t.timestamps
    end
  end
end
