class AddCommentsToBids < ActiveRecord::Migration
  def change
    add_column :bids, :message, :text
  end
end
