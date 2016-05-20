class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.search(user_id, group_id)
    where(["user_id = ? AND group_id = ? ", "#{user_id}", "#{group_id}"])
	end

  def self.is_active(user_id, group_id)
    return Membership.search(user_id, group_id).first.active
  end

end
