class Chore < ActiveRecord::Base
  #belongs_to :user
  belongs_to :group
  has_many :chore_rotations

  def self.remind()
    @incomplete_chores = incomplete()
    for incomplete_chore in @incomplete_chores.each
      if Date.today == Date.parse(incomplete_chore.date) - 1
        @user = User.find(incomplete_chore.user_id)
        @group = Group.find(incomplete_chore.group_id)
        @chore = incomplete_chore
        UserMailer.chore_reminder_email(@user, @group, @chore).deliver_now
      end
    end
  end

  def self.incomplete()
    where(["complete = false"])
  end

  def self.destroy_all_completed(user_id)
    @chores = where(["complete = true AND user_id = ?", "#{user_id}"])
    for chore in @chores.each
      ChoreRotation.remove_rotation(chore.id)
      chore.destroy
    end
  end

  def self.search_by_group_id(group_id)
		where(["group_id = ?", "#{group_id}"])
	end

end
