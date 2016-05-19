class AddIdToChores < ActiveRecord::Migration
  def change
    add_column :chores, :user_id, :integer
    add_column :chores, :group_id, :integer
  end
end
