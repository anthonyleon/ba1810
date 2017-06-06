class AddDestinationToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :destination, index: true, foreign_key: true
  end
end
