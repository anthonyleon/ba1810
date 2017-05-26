class AddDefaultsToProjects < ActiveRecord::Migration
  def change
  	change_column :projects, :reference_num, :string, null: false
  	change_column :projects, :description, :string, default: "Not Provided"
  end
end
