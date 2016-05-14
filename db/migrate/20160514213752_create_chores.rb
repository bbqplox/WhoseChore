class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.string :Name
      t.string :Description
      t.string :Date

      t.timestamps null: false
    end
  end
end
