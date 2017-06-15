class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :company, index: true, foreign_key: true
      t.references :auction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
