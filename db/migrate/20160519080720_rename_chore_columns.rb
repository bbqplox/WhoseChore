class RenameChoreColumns < ActiveRecord::Migration
  def change
    rename_column :chores, :Name, :name
    rename_column :chores, :Description, :description
    rename_column :chores, :Date, :date
  end
end
