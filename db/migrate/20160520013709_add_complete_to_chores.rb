class AddCompleteToChores < ActiveRecord::Migration
  def change
    add_column :chores, :complete, :boolean, :default=>false
  end
end
