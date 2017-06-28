class ChangesCompanyReferencesToUsers < ActiveRecord::Migration
  def change
    remove_column :auctions, :company_id, :integer
    add_reference :auctions, :user, index: true, foreign_key: true

    remove_column :invites, :company_id, :integer
    add_reference :invites, :user, index: true, foreign_key: true

    remove_column :projects, :company_id, :integer
    add_reference :projects, :user, index: true, foreign_key: true

    remove_column :notifications, :company_id, :integer
    add_reference :notifications, :user, index: true, foreign_key: true
  end
end