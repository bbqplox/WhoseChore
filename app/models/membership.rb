class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.search(user_id, group_id)
    where(["user_id = ? AND group_id = ? ", "#{user_id}", "#{group_id}"])
	end

  def self.is_active(user_id, group_id)
    Membership.search(user_id, group_id).first.active
  end

  def self.give_user_admin(user_id, group_id)
    @membership = search(user_id, group_id).first
    @membership.admin = true
    @membership.save
  end

end
