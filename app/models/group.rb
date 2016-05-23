class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  has_many :administrators
  has_many :chores
  has_many :chore_rotations

  def self.active_user_groups(user_id)
    @memberships = Membership.active_user_memberships(user_id)
    @groups = []
    @memberships.each do |membership|
      @group = Group.find(membership.group_id)
      @groups << @group
    end
    @groups
  end

end
