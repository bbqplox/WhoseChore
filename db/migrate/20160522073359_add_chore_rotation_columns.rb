class AddChoreRotationColumns < ActiveRecord::Migration
  def change
    add_column :chore_rotations, :chore_id, :integer
    add_column :chore_rotations, :group_id, :integer
    add_column :chore_rotations, :user_id, :integer
    add_column :chore_rotations, :order, :integer, default: 0
  end
end
