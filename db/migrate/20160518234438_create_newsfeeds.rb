class CreateNewsfeeds < ActiveRecord::Migration
  def change
    create_table :newsfeeds do |t|

      t.timestamps null: false
    end
  end
end
