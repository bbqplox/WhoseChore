class GroupInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.search_by_user(user_id)
    where(["user_id = ?", "#{user_id}"])
  end

  def self.search_by_group(group_id)
    where(["group_id = ?", "#{group_id}"])
  end

  def self.destroy_all_from_group(group_id)
    @invites = search_by_group(group_id)
    for invite in @invites
      invite.destroy
    end
  end

end
