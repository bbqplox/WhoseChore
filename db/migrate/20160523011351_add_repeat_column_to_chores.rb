class AddRepeatColumnToChores < ActiveRecord::Migration
  def change
    add_column :chores, :repeat_days, :integer, :default => -1
  end
end
