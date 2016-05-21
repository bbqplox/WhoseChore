class GroupInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.search_by_user(user_id)
    where(["user_id = ?", "#{user_id}"])
  end
end
