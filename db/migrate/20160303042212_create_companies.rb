class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end
    add_index :companies, :name, unique: true
    add_index :companies, :email, unique: true
  end
end
