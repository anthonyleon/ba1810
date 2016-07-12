class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.boolean :read?, default: false
      t.boolean :unread?, default: true
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
