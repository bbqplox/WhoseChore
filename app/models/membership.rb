class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.search(user, group)
    where(["user_id = ? AND group_id = ? ", "#{user}", "#{group}"])
	end

end
