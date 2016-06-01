class AddRewardsColumn < ActiveRecord::Migration
  def change
    add_column :rewards, :user_id, :integer, :default => -1
    add_column :rewards, :group_id, :integer
    add_column :rewards, :claimed_time, :date, :default => Date.today
  end
end
