class AddProjectToAuctions < ActiveRecord::Migration
  def change
    add_reference :auctions, :project, index: true, foreign_key: true
  end
end
