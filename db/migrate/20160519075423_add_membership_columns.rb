class AddMembershipColumns < ActiveRecord::Migration
  def change
    add_column :memberships, :admin, :boolean
    add_column :memberships, :active, :boolean
    add_column :memberships, :chore_score, :integer
  end
end
