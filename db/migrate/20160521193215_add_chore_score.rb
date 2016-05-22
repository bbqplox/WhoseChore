class AddChoreScore < ActiveRecord::Migration
  def change
    add_column :chores, :score, :integer, :default=>0
  end
end
