class CreateChoreRotations < ActiveRecord::Migration
  def change
    create_table :chore_rotations do |t|

      t.timestamps null: false
    end
  end
end
